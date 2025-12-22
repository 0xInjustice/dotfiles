#!/usr/bin/env bash
set -euo pipefail

domain="$1"

katana -u livesubdomains.txt -d &
waybackurls "$domain" | sort -u > urls-wayback.txt &
gau "$domain" | sort -u > urls-gau.txt &
urlfinder -d "$domain" | sort -u > urls-urlfinder.txt &
wait
