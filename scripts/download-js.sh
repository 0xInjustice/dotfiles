#!/usr/bin/env bash

FILE="$1"
JOBS=10

mkdir -p js/200 js/403 js/404

process_url() {
    url="$1"

    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    clean=$(echo "$url" | sed 's|^https\?://||')
    host=$(echo "$clean" | cut -d/ -f1)
    path=$(echo "$clean" | cut -d/ -f2-)

    if [[ "$http_code" -eq 200 ]]; then
        outdir="js/200/$host/$(dirname "$path")"
        outfile="js/200/$host/$path"

        mkdir -p "$outdir"
        curl -s "$url" -o "$outfile"

        {
            flock 200
            echo "$host/$path"
        } >> js/200/urls.txt 200>js/200/urls.lock

    elif [[ "$http_code" -eq 403 ]]; then
        echo "$url" >> js/403/urls.txt

    elif [[ "$http_code" -eq 404 ]]; then
        echo "$url" >> js/404/urls.txt
    fi
}

export -f process_url

xargs -n 1 -P "$JOBS" bash -c 'process_url "$@"' _ < "$FILE"
