#!/usr/bin/env python3

# Fast Virtual Machine switcher for i3, Looking Glass and Barrier/Synergy
#
# Switches to Looking Glass window, makes it fullscreen and presses
# Barrier/Synergy capture key. When captured, switches to last focused window
# before capture, makes Looking Glass windowed and presses Barrier/Synergy
# release key.
#
# Requires Python packages: keyboard (requires sudo), i3ipc
#
# Barrier/Synergy keys must be defined in its configuration as:
#   keystroke(key) = lockCursorToScreen(off), switchToScreen(host)
#   keystroke(key) = switchToScreen(guest), lockCursorToScreen(on)
#
# Note: Barrier/Synergy grabs keybinds and prevents them from being passed to
# other X11 applications on host (screens support for keystrokes added in 1.10
# only support guests), 'keyboard' library reads raw device files instead so we
# can capture it even when Barrier/Synergy sends it to the guest.

# pip
import keyboard
import i3ipc

KEY_SWITCH = 188  # scancode 188 = F18
KEY_SYNERGY_CAPTURE = 186  # scancode 186 = F16
KEY_SYNERGY_RELEASE = 187  # scancode 187 = F17

i3 = i3ipc.Connection(auto_reconnect=True)
last_window = None


def switch():
    global last_window
    lg_windows = i3.get_tree().find_classed("looking-glass-client")

    if len(lg_windows) < 1:
        print("[vm-switch] ERROR: No Looking Glass client window found!")
        return
    if len(lg_windows) > 1:
        print("[vm-switch] WARNING: Multiple Looking Glass client windows found!")

    lg_window = lg_windows[0]

    if lg_window.focused:
        # Switch to last focused window
        if last_window:
            # Focus before some other action due to keybinds not being
            # recognized immediately if focusing is last
            last_window.command("focus; fullscreen disable")

        lg_window.command("fullscreen disable")
        keyboard.press_and_release(KEY_SYNERGY_RELEASE)
    else:
        # Save currently focused window and focus Looking Glass
        last_window = i3.get_tree().find_focused()

        # Focus before fullscreen due to some issue with keybinds not being
        # recognized immediately if focusing last
        lg_window.command("focus; fullscreen enable")
        keyboard.press_and_release(KEY_SYNERGY_CAPTURE)


print("Waiting for switch ...")

# Wait for key to be pressed and call switch synchronously to be able to wait
# for required processes to do their job
try:
    while True:
        keyboard.wait(KEY_SWITCH, suppress=True, trigger_on_release=True)
        switch()
except KeyboardInterrupt:
    pass
