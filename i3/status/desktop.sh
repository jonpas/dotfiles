#!/bin/bash

de=""

# KDE Plasma
if pgrep "startplasma" > /dev/null; then
    de="Plasma"
fi

echo {\"icon\": \"gpu\", \"text\": \"$de\"}
