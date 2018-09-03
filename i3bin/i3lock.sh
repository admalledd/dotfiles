#!/usr/bin/env bash
set -eu

screenshot=$(mktemp --tmpdir i3lock-scrot-XXX.png)
lock=$(mktemp --tmpdir i3lock-final-XXX.png)
overlay="${HOME}/src/adm-dotfiles/i3lockbg.png"

scrot -d0 ${screenshot}
convert ${screenshot} -blur 0x9 -modulate 100,40 \
    -gravity center ${overlay} -composite \
    ${lock}

#feh ${lock}
#i3lock -i ${lock}

trap "rm '${screenshot}' '${lock}'" EXIT