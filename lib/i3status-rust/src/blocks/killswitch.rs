use std::io::{BufReader, BufRead};
use std::fs::File;
use std::time::{Duration, Instant};
use chan::Sender;

use crate::block::{Block, ConfigBlock};
use crate::config::Config;
use crate::de::deserialize_duration;
use crate::errors::*;
use crate::widgets::text::TextWidget;
use crate::widget::{I3BarWidget, State};
use crate::scheduler::Task;

use uuid::Uuid;

pub struct Killswitch {
    id: String,
    update_interval: Duration,
    active: bool,
    widget: TextWidget,
    last_update: Instant,
}

#[derive(Deserialize, Debug, Default, Clone)]
#[serde(deny_unknown_fields)]
pub struct KillswitchConfig {
    /// Update interval in seconds
    #[serde(default = "KillswitchConfig::default_interval", deserialize_with = "deserialize_duration")]
    pub interval: Duration,
}


impl KillswitchConfig {
    fn default_interval() -> Duration {
        Duration::from_secs(5)
    }
}

impl ConfigBlock for Killswitch {
    type Config = KillswitchConfig;

    fn new(block_config: Self::Config, config: Config, _tx_update_request: Sender<Task>) -> Result<Self> {
        Ok(Killswitch {
            id: Uuid::new_v4().simple().to_string(),
            update_interval: block_config.interval,
            active: is_killswitch_active(),
            widget: TextWidget::new(config.clone()).with_icon("killswitch"),
            last_update: Instant::now() - Duration::from_secs(30),
        })
    }
}

fn is_killswitch_active() -> bool {
    let file = File::open("/etc/default/ufw").unwrap();
    for line in BufReader::new(file).lines() {
        if line.unwrap() == "DEFAULT_OUTPUT_POLICY=\"DROP\"" {
            return true;
        }
    }

    false
}

impl Block for Killswitch {
    fn update(&mut self) -> Result<Option<Duration>> {
        let now = Instant::now();
        self.active = is_killswitch_active();
        self.last_update = now;

        self.widget.set_text(if self.active { "up" } else { "down" }.to_string());
        self.widget.set_state(if self.active { State::Good } else { State::Critical });

        Ok(Some(self.update_interval))
    }

    fn view(&self) -> Vec<&I3BarWidget> {
        vec![&self.widget]
    }

    fn id(&self) -> &str {
        &self.id
    }
}
