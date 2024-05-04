#!/usr/bin/env bash
set -euo pipefail
export NO_COLOR=true
export PATH="$HOME/.local/bin:$PATH"
### setup:
{
    rm -rf ./output.txt go.mod ./dagger*
    go mod init github.com/skalt/weird.name.repro
    curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
    command -v dagger
} >/dev/null
### repro
{
    dagger init --name=weird.name.repro
    dagger develop --sdk=go
    # name=weird.name.repro works fine
    {
        dagger version
        cat dagger.json | jq .name
    } | sed 's/^/# /g'
    dagger functions 2>&1

    rm -rf ./dagger*
    dagger init --name=w.eird.name.repro 
    dagger develop --sdk=go

    # name=w.eird.name.repro fails
    {
        dagger version
        cat dagger.json | jq .name
    } | sed 's/^/# /g'
    dagger functions || true
} 2>&1 | tee ./output.txt
