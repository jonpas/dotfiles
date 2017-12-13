#!/usr/bin/env python3

import os
import sys
import shutil
import subprocess
import re

if "--left" in sys.argv:
    colors = {
        "red": "\\[\\e[1;31m\\]",
        "green": "\\[\\e[1;32m\\]",
        "blue": "\\[\\e[1;36m\\]",
        "yellow": "\\[\\e[1;33m\\]",
        "reset": "\\[\\e[0m\\]"
    }
else:
    colors = {
        "red": "\33[1;31m",
        "green": "\33[1;32m",
        "blue": "\33[1;36m",
        "yellow": "\33[1;33m",
        "reset": "\33[0m"
    }
correction = 0

def get_terminal_size():
    lines, cols = subprocess.check_output(["stty", "size"]).split()
    return int(cols), int(lines)

def is_ssh():
    try:
        import psutil

        if "SSH_TTY" in os.environ:
            return True

        proc = psutil.Process(os.getpid())
        while proc is not None:
            if "ssh" in proc.name():
                return True
            proc = proc.parent()

        return False
    except:
        return "SSH_TTY" in os.environ

def segment_whoami():
    global colors

    user = os.environ["USER"]
    host = str(subprocess.check_output("hostname"), "utf-8")[:-1]

    cols, lines = get_terminal_size()

    if len(user) + len(host) + 3 > cols / 5:
        host = host[0]
    if len(user) + 4 > cols / 5:
        user = user[0]

    usercolor = colors["green"]
    if os.geteuid() == 0:
        usercolor = colors["red"]

    hostcolor = colors["blue"]
    if is_ssh():
        hostcolor = colors["yellow"]

    return "[{}{}{}@{}{}{}]".format(
        usercolor, user, colors["reset"],
        hostcolor, host, colors["reset"]
    )

def segment_prompt():
    global colors

    prompt = "$"
    if os.geteuid() == 0:
        prompt = "#"

    if "ERR" in os.environ and int(os.environ["ERR"]) != 0:
        return "{}{}{}".format(colors["red"], prompt, colors["reset"])

    return prompt

def segment_git():
    global colors, correction

    try:
        status = subprocess.check_output(["git", "status"], env={"LC_ALL": "en_US"}, stderr=subprocess.PIPE)
    except:
        return ""

    status = str(status, "utf-8")[:-1]
    lines = status.split("\n")
    for i, l in enumerate(lines):
        if l[:2] == "# ":
            lines[i] = l[2:]
    rev = lines[0].split(" ")[-1]

    if "detached" in lines[0]:
        gitseg = "[{}]".format(rev)
    else:
        gitseg = "({})".format(rev)

    correction = correction + 11

    local, origin = 0, 0
    if "have diverged" in lines[1]:
        local, origin = lines[2].split(" ")[2], lines[2].split(" ")[4]
    elif "is behind" in lines[1]:
        origin = lines[1].split(" ")[6]
    elif "is ahead" in lines[1]:
        local = lines[1].split(" ")[7]

    if int(local) > 0:
        gitseg = "{}^ ".format(local) + gitseg
    if int(origin) > 0:
        gitseg = "{}v ".format(origin) + gitseg

    if "Untracked" in status or "Changes not staged" in status:
        return colors["red"] + gitseg + colors["reset"]

    if "Changes to be committed" in status:
        return colors["yellow"] + gitseg + colors["reset"]

    return colors["green"] + gitseg + colors["reset"]

def segment_path():
    global colors

    path = os.getcwd()
    home = os.environ["HOME"]

    if path[:len(home)] == home:
        path = "~" + path[len(home):]

    cols, lines = get_terminal_size()
    while len(path) > cols / 5 and re.search(r"\/[^/][^/]+\/", path) is not None:
        path = re.sub(r"\/([^/])[^/]+\/", r"/\1/", path, count=1)

    return path

def main():
    global correction

    cols, lines = get_terminal_size()

    if "--right" in sys.argv:
        right = "{} {}".format(segment_git(), segment_path())
        print(right.rjust(cols + correction - 1), end="\r")

    if "--left" in sys.argv:
        left = "{} {}".format(segment_whoami(), segment_prompt())
        print(left, end=" ")

    if "--debug" in sys.argv:
        import time
        for f in ["get_terminal_size", "segment_whoami", "segment_prompt",
                "segment_git", "segment_path"]:
            t = time.time()
            globals()[f]()
            print("{:20} {}".format(f, time.time() - t))

if __name__ == "__main__":
    main()
