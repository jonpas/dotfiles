use std::env;
use std::path::PathBuf;

use colored::*;
use gethostname::gethostname;
use git2::{Branch, Repository};
use psutil::getpid;
use psutil::process::Process;
use terminal_size::{Width, Height};
use users::get_current_uid;

const COLOR_RED: &str = "\\[\\e[1;31m\\]";
const COLOR_GREEN: &str = "\\[\\e[1;32m\\]";
const COLOR_BLUE: &str = "\\[\\e[1;36m\\]";
const COLOR_YELLOW: &str = "\\[\\e[1;33m\\]";
const COLOR_RESET: &str = "\\[\\e[0m\\]";

fn terminal_size() -> (usize, usize) {
    if let Some((Width(w), Height(h))) = terminal_size::terminal_size() {
        (w.into(), h.into())
    } else {
        (80, 30)
    }
}

fn is_ssh() -> bool {
    let mut process = Process::new(getpid()).unwrap();
    loop {
        if process.comm.find("ssh").is_some() {
            return true;
        }

        if let Ok(proc) = Process::new(process.ppid) {
            process = proc
        } else {
            break;
        }
    }

    false
}

fn display_left() {
    // todo
    //let (w, _) = terminal_size();
    //println!("{:?}", w);
    let uid = get_current_uid();

    let user = env::var("USER").unwrap_or("".into());
    let host = gethostname().into_string().unwrap_or("".into());

    // todo
    //if user.len() + host.len() + 3 > w / 5 {
    //    host.truncate(1);
    //}

    //if user.len() + 4 > w / 5 {
    //    user.truncate(1);
    //}

    let user = if uid == 0 {
        COLOR_RED.to_owned() + &user + COLOR_RESET
    } else {
        COLOR_GREEN.to_owned() + &user + COLOR_RESET
    };

    let host = if is_ssh() {
        COLOR_YELLOW.to_owned() + &host + COLOR_RESET
    } else {
        COLOR_BLUE.to_owned() + &host + COLOR_RESET
    };

    let prompt = if uid == 0 { "#" } else { "$" };
    let prompt = if env::var("ERR").unwrap_or("0".into()) != "0" {
        COLOR_RED.to_owned() + &prompt + COLOR_RESET
    } else {
        prompt.to_owned()
    };

    print!("[{}@{}] {} ", user, host, prompt);
}

fn display_right() {
    let (w, _) = terminal_size();

    let mut path = env::current_dir().unwrap();

    let mut git = "".bright_white().bold();
    if let Ok(repo) = Repository::discover(&path) {
        if let Ok(head) = repo.head() {
            let s = if head.is_branch() {
                let branch = Branch::wrap(head);

                let mut ahead = "".into();
                let mut behind = "".into();
                if let Ok(upstream) = branch.upstream() {
                    let l = branch.get().target().unwrap();
                    let u = upstream.get().target().unwrap();
                    let (a, b) = repo.graph_ahead_behind(l, u).unwrap_or((0, 0));

                    if a > 0 {
                        ahead = format!("{}^ ", a);
                    }
                    if b > 0 {
                        behind = format!("{}v ", b);
                    }
                }

                format!("{}{}({})", ahead, behind, branch.get().shorthand().unwrap_or(""))
            } else if let Ok(tag) = head.peel_to_tag() {
                format!("[{}]", tag.name().unwrap()) // todo
            } else if let Ok(commit) = head.peel_to_commit() {
                format!("[{}]", &commit.id().to_string()[..8])
            } else {
                format!("[{}]", head.shorthand().unwrap_or(""))
            };

            let mut dirt: u8 = 0;
            for entry in repo.statuses(None).unwrap().iter() {
                let status = entry.status();

                if status.is_index_new() ||
                    status.is_index_modified() ||
                    status.is_index_deleted() ||
                    status.is_index_renamed() ||
                    status.is_index_typechange()
                {
                    dirt = std::cmp::max(1, dirt);
                }

                if status.is_wt_new() ||
                    status.is_wt_modified() ||
                    status.is_wt_deleted() ||
                    status.is_wt_renamed() ||
                    status.is_wt_typechange() ||
                    status.is_conflicted()
                {
                    dirt = 2;
                    break;
                }
            }

            git = match dirt {
                2 => s.bright_red().bold(),
                1 => s.bright_yellow().bold(),
                _ => s.bright_green().bold()
            };
        }
    }

    let home = PathBuf::from(env::var("HOME").unwrap_or("".into()));
    if let Ok(result) = path.strip_prefix(home) {
        if result.components().next().is_some() {
            path = PathBuf::from("~").join(result);
        } else {
            path = PathBuf::from("~");
        }
    }

    while path.to_str().unwrap().len() >  w / 5 && path.iter().any(|os| os.len() > 1) {
        let mut components: Vec<String> = path.iter()
            .map(|os| os.to_str().unwrap().into())
            .collect();
        for c in components.iter_mut() {
            if c.len() > 1 {
                c.truncate(1);
                break;
            }
        }
        path = components.iter().collect();
    }

    let output = format!("{} {}", git, path.display());
    print!("{:>1$}\r", output, w + 10)
}

fn main() {
    if env::args().any(|a| a == "--right") {
        display_right();
    }

    if env::args().any(|a| a == "--left") {
        display_left();
    }
}
