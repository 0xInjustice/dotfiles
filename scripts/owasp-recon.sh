#!/usr/bin/env bash
set -euo pipefail

domain="$1"
workdir="./$domain"
mkdir -p "$workdir"
mkdir -p "$workdir/logs"
mkdir -p "$workdir/screenshots"

dig +short "$domain" >/dev/null || exit 1

findomain -t "$domain" -u "$workdir/findomain.txt" 2>"$workdir/logs/findomain.log" &
subfinder -d "$domain" -silent -all -recursive -o "$workdir/subfinder.txt" 2>"$workdir/logs/subfinder.log" &
assetfinder -subs-only "$domain" > "$workdir/assetfinder.txt" 2>"$workdir/logs/assetfinder.log" &
wait

sort -u "$workdir"/*.txt | grep -v '^$' > "$workdir/subdomains.txt"

dnsrecon -d "$domain" -t axfr -D /usr/share/wordlists/dnsmap.txt -f \
  > "$workdir/axfr.txt" 2>"$workdir/logs/axfr.log" || true

dnsenum "$domain" > "$workdir/dnsenum.txt" 2>"$workdir/logs/dnsenum.log" || true

tlsx -l "$workdir/subdomains.txt" -san -cn -issuer -exp -silent \
  > "$workdir/tlsx-meta.txt" 2>"$workdir/logs/tlsx.log"

amass intel -d "$domain" -whois \
  > "$workdir/asn.txt" 2>"$workdir/logs/asn.log" || true

curl -s "https://api.hackertarget.com/aslookup/?q=$domain" \
  > "$workdir/asn-alt.txt" 2>"$workdir/logs/asn-alt.log" || true

asn="$(grep -oE 'AS[0-9]+' "$workdir"/asn*.txt | head -n1 || true)"

if [ -n "${asn:-}" ]; then
  whois -h whois.radb.net -- "-i origin $asn" \
    | grep -Eo "([0-9.]+){1,4}/[0-9]{1,2}" \
    | sort -u > "$workdir/netblocks.txt" || true

  naabu -iL "$workdir/netblocks.txt" -top-ports 200 -rate 8000 -silent \
    > "$workdir/naabu-ports.txt" 2>"$workdir/logs/naabu.log" || true
fi

httpx -l "$workdir/subdomains.txt" -mc 404 -silent \
  | cut -d ' ' -f1 > "$workdir/subdomains_404.txt" 2>"$workdir/logs/httpx404.log" &

httpx -l "$workdir/subdomains.txt" -mc 403 -silent \
  | cut -d ' ' -f1 > "$workdir/subdomains_403.txt" 2>"$workdir/logs/httpx403.log" &

httpx -l "$workdir/subdomains.txt" \
  -ports 80,443,8080,8000,8888 -threads 200 -timeout 5 -retries 3 -silent \
  > "$workdir/livesubdomains.txt" 2>"$workdir/logs/httpx_live.log" &
wait

dirsearch \
  --exclude-status=404 \
  -w ~/tools/ultimate_discovery/ultimate-discovery.txt \
  -l "$workdir/subdomains_404.txt" \
  -t 250 \
  -o "$workdir/results_404.txt" \
  2>"$workdir/logs/dirsearch.log" &

katana -u "$workdir/livesubdomains.txt" -d 2 -js-crawl -silent \
  -o "$workdir/urls-katana.txt" 2>"$workdir/logs/katana.log" &

waybackurls "$domain" | sort -u \
  > "$workdir/urls-wayback.txt" 2>"$workdir/logs/wayback.log" &

gau "$domain" | sort -u \
  > "$workdir/urls-gau.txt" 2>"$workdir/logs/gau.log" &

urlfinder -d "$domain" | sort -u \
  > "$workdir/urls-urlfinder.txt" 2>"$workdir/logs/urlfinder.log" &
wait

cat "$workdir"/urls-* | sort -u > "$workdir/urls-all.txt"

katana -u "$workdir/livesubdomains.txt" -d 2 -js-crawl -silent \
  | grep -E "\.js" | sort -u > "$workdir/js-files.txt"

xargs -a "$workdir/js-files.txt" -I@ bash -c "curl -s @ | unfurl --unique keys" \
  > "$workdir/params-js.txt" 2>"$workdir/logs/js-params.log" || true

nuclei -l "$workdir/livesubdomains.txt" -as -silent \
  -o "$workdir/nuclei-scan.txt" 2>"$workdir/logs/nuclei.log"

s3scanner scan --include-aws --include-gcp --include-azure "$domain" \
  > "$workdir/buckets.txt" 2>"$workdir/logs/buckets.log" || true

git-hound -d "$domain" --no-banner \
  > "$workdir/github-leaks.txt" 2>"$workdir/logs/githound.log" || true

aquatone -scan-timeout 300000 -threads 8 -out "$workdir/screenshots" \
  < "$workdir/livesubdomains.txt" 2>"$workdir/logs/aquatone.log"
