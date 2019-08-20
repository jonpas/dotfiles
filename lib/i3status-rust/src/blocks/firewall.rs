use std::io::{BufReader, BufRead};
use std::fs::File;
use std::process::Command;
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

pub struct Firewall {
    id: String,
    update_interval: Duration,
    active: bool,
    widget: TextWidget,
    last_update: Instant,
}

#[derive(Deserialize, Debug, Default, Clone)]
#[serde(deny_unknown_fields)]
pub struct FirewallConfig {
    /// Update interval in seconds
    #[serde(default = "FirewallConfig::default_interval", deserialize_with = "deserialize_duration")]
    pub interval: Duration,
}


impl FirewallConfig {
    fn default_interval() -> Duration {
        Duration::from_secs(5)
    }
}

impl ConfigBlock for Firewall {
    type Config = FirewallConfig;

    fn new(block_config: Self::Config, config: Config, _tx_update_request: Sender<Task>) -> Result<Self> {
        Ok(Firewall {
            id: Uuid::new_v4().simple().to_string(),
            update_interval: block_config.interval,
            active: is_ufw_active(),
            widget: TextWidget::new(config.clone()).with_icon("firewall"),
            last_update: Instant::now() - Duration::from_secs(30),
        })
    }
}

fn is_ufw_active() -> bool {
    let mut enabled = false;
    let file = File::open("/etc/ufw/ufw.conf").unwrap();
    for line in BufReader::new(file).lines() {
        if line.unwrap() == "ENABLED=yes" {
            enabled = true;
            break;
        }
    }

    let active = String::from_utf8(
            Command::new("systemctl")
                .env("LC_ALL", "C")
                .args(&[
                    "status",
                    "ufw"
                ])
                .output()
                .unwrap()
                .stdout,
            ).unwrap()
            .lines()
            .filter(|line| line.contains("Active: active "))
            .count() > 0;

    enabled && active
}

impl Block for Firewall {
    fn update(&mut self) -> Result<Option<Duration>> {
        let now = Instant::now();
        self.active = is_ufw_active();
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
