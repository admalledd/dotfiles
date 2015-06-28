#!/usr/bin/env bash
set -eu

screenshot=$(mktemp --tmpdir i3lock-scrot-XXX.png)
lock=$(mktemp --tmpdir i3lock-final-XXX.png)
overlay="${HOME}/.i3/i3lockbg.png"

scrot -d0 ${screenshot}
convert ${screenshot} -blur 0x5 -modulate 100,40 \
    -gravity center ${overlay} -composite \
    ${lock}

#ristretto ${lock}
i3lock -i ${lock}

trap "rm '${screenshot}' '${lock}'" EXIT