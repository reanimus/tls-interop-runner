#!/bin/bash
#
# Builds and tags the interop images that will be used for the docker-compose.yml
# environment

THIS_SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

set -uexo pipefail

do_build() {
    local dir
    local image
    dir="$1"

    [ ! -d "$dir" ] && { echo "Directory $dir does not exist." >&2; exit 1; }

    if [ -x "$dir/build" ]; then
        image="$("$dir/build")"
    else
        [ ! -f "$dir/Dockerfile" ] && { echo "Directory $dir missing Dockerfile." >&2; exit 1; }
        imgfile="$(mktemp)"
        (cd "$dir" && docker build --iidfile "$imgfile" . >&2 )
        image="$(cat "$imgfile")"
    fi
    echo "$image"
}

docker image tag "$(do_build "$CLIENT_SRC/$CLIENT")" "tls-endpoint-$CLIENT"
docker image tag "$(do_build "$SERVER_SRC/$SERVER")" "tls-endpoint-$SERVER"
docker image tag "$(do_build "$THIS_SCRIPT_DIR/../network")" "tls-interop-network"
