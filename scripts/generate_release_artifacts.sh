#!/usr/bin/env bash

set -e
set -u
set -x
set -o pipefail

function main() {
    mkdir -p release

    cp resources/* release/

    VERSION="v$(cat .release-please-manifest.json | jq -r '."."')"

    find release/ -type f -exec \
        sed -i'.bak' "s/canary/${VERSION}/g" {} \;

    rm release/*.bak
}

main
