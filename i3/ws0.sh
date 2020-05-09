i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"

i3-sensible-terminal -e htop -t "Terminal: htop" &
i3-sensible-terminal -e 'watch -t "grep \"cpu MHz\" /proc/cpuinfo && sensors -A coretemp-isa-0000"' -t "Terminal: sensors" &
i3-sensible-terminal -e 'watch -t progress -q' -t "Terminal: progress" &
i3-sensible-terminal -t 'Terminal: WinVM' &
firefox --new-window about:logo &
