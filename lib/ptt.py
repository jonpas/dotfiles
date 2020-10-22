#!/usr/bin/env python3

# Push-To-Talk for various programs without native support or for in-browser use.
#
# Unmutes on keybind press and mutes on release.
#
# Note: sudo is required, as applications can grab keybinds and prevent
# them from being passed to other X11 applications, 'keyboard' library reads
# raw device files instead so we can capture it at all times.

# pip
import keyboard
import i3ipc

KEY_PTT = "pause"
MAPPINGS = {
    # (class, mute key) - searches in order
    "\\| Jitsi Meet": "m",
    "\\| Microsoft Teams": "ctrl+shift+m"  # desktop or browser (Chromium)
}

i3 = i3ipc.Connection(auto_reconnect=True)
last_window = None


def find_program(tree):
    for program, keybind in MAPPINGS.items():
        window = tree.find_named(program)
        if window:
            return window[0], keybind

    return None, None


def ptt(down):
    global last_window
    tree = i3.get_tree()

    if down:
        window, keybind = find_program(tree)

        if window and not last_window:
            last_window = tree.find_focused()

            window.command("focus")
            keyboard.press_and_release(keybind)
            last_window.command("focus")
    elif last_window:
        window, keybind = find_program(tree)

        if window:
            window.command("focus")
            keyboard.press_and_release(keybind)

        last_window.command("focus")
        last_window = None


print("Waiting for PTT press ...")

keyboard.add_hotkey(KEY_PTT, ptt, args=[True], suppress=True, trigger_on_release=False)
keyboard.add_hotkey(KEY_PTT, ptt, args=[False], suppress=True, trigger_on_release=True)

try:
    keyboard.wait()
except KeyboardInterrupt:
    pass
