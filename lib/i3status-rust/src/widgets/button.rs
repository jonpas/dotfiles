use crate::config::Config;
use crate::widget::State;
use serde_json::value::Value;
use super::super::widget::I3BarWidget;

#[derive(Clone, Debug)]
pub struct ButtonWidget {
    content: Option<String>,
    icon: Option<String>,
    state: State,
    id: String,
    rendered: Value,
    cached_output: Option<String>,
    config: Config,
    bg: Option<String>,
    fg: Option<String>,
    separator: Option<String>,
}

impl ButtonWidget {
    pub fn new(config: Config, id: &str) -> Self {
        ButtonWidget {
            content: None,
            icon: None,
            state: State::Idle,
            id: String::from(id),
            rendered: json!({
                "full_text": "",
                "separator": false,
                "separator_block_width": 0,
                "background": "#000000",
                "color": "#000000",
                "markup": "pango"
            }),
            config,
            cached_output: None,
            bg: None,
            fg: None,
            separator: None
        }
    }

    pub fn with_icon(mut self, name: &str) -> Self {
        self.icon = self.config.icons.get(name).cloned();
        self.update();
        self
    }

    pub fn with_content(mut self, content: Option<String>) -> Self {
        self.content = content;
        self.update();
        self
    }

    pub fn with_text(mut self, content: &str) -> Self {
        self.content = Some(String::from(content));
        self.update();
        self
    }

    pub fn with_state(mut self, state: State) -> Self {
        self.state = state;
        self.update();
        self
    }

    pub fn with_bg<S: Into<String>>(mut self, bg: S) -> Self {
        self.bg = Some(bg.into());
        self.update();
        self
    }

    pub fn with_fg<S: Into<String>>(mut self, fg: S) -> Self {
        self.fg = Some(fg.into());
        self.update();
        self
    }

    pub fn with_separator<S: Into<String>>(mut self, separator: S) -> Self {
        self.separator = Some(separator.into());
        self.update();
        self
    }

    pub fn set_text<S: Into<String>>(&mut self, content: S) {
        self.content = Some(content.into());
        self.update();
    }

    pub fn set_icon(&mut self, name: &str) {
        self.icon = self.config.icons.get(name).cloned();
        self.update();
    }

    pub fn set_state(&mut self, state: State) {
        self.state = state;
        self.update();
    }

    fn update(&mut self) {
        let (cfg_bg, cfg_fg) = self.state.theme_keys(&self.config.theme);

        let key_bg = self.bg.clone().unwrap_or(cfg_bg.to_string());
        let key_fg = self.fg.clone().unwrap_or(cfg_fg.to_string());

        self.rendered = json!({
            "full_text": format!("{}{}{} ",
                                self.separator.clone().unwrap_or_else(|| String::from("")),
                                self.icon.clone().unwrap_or_else(|| String::from(" ")),
                                self.content.clone().unwrap_or_else(|| String::from(""))),
            "separator": false,
            "name": self.id.clone(),
            "separator_block_width": 0,
            "background": key_bg,
            "color": key_fg,
            "markup": "pango"
        });

        self.cached_output = Some(self.rendered.to_string());
    }
}

impl I3BarWidget for ButtonWidget {
    fn to_string(&self) -> String {
        self.cached_output
            .clone()
            .unwrap_or_else(|| self.rendered.to_string())
    }

    fn get_rendered(&self) -> &Value {
        &self.rendered
    }
}
