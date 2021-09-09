#!/bin/bash

SCRIPT=$(basename $0)

START_WEBSERVER() {
    [ -d simple-webslides ] && rm -rf simple-webslides
    git clone https://github.com/mjbright/simple-webslides
    cd simple-webslides

    sed -i.bak "s/served from carbon/served from $(hostname -f)/" index.html
    python3 -m http.server --bind 0.0.0.0 80  >/var/webserver.log 2>&1 &
}

## == Functions ================================================================

die() { echo "$0: $*" >&2; exit 1; }

## == Main ===============================================

START_WEBSERVER


