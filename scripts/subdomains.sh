#!/usr/bin/env bash
set -euo pipefail

domain="$1"

dig +short "$domain" >/dev/null || exit 1

findomain -t "$domain" -u findomain.txt &
subfinder -d "$domain" -silent -all -recursive -o subfinder.txt &
assetfinder -subs-only "$domain" > assetfinder.txt &

wait

cat findomain.txt subfinder.txt assetfinder.txt | sort -u > subdomains.txt
rm findomain.txt subfinder.txt assetfinder.txt

httpx-pd -l subdomains.txt -ports 80,443,8080,8000,8888 -threads 200 -timeout 5 -retries 3 -silent > livesubdomains.txt &

httpx-pd -l subdomains.txt -mc 403 > subdomains_403.txt & 
httpx-pd -l subdomains.txt -mc 404 > subdomains_404.txt &

wait 

