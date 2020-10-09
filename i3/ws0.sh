i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"

i3-sensible-terminal -e htop -t "Terminal: htop" &

if [ $(hostname) = "loki" ]; then
    i3-sensible-terminal -e 'watch -t "sensors zenpower-pci-00c3 -A | grep °C"' -t "Terminal: sensors" &
else
    i3-sensible-terminal -e 'watch -t "sensors coretemp-isa-0000 -A | grep °C"' -t "Terminal: sensors" &
fi

i3-sensible-terminal -e 'watch -t progress -q' -t "Terminal: progress" &
i3-sensible-terminal -t 'Terminal: WinVM' &
firefox --new-window about:logo &
