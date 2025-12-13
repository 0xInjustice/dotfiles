
#!/usr/bin/env bash
set -euo pipefail

gfcat() {
    file="urls-all.txt"
    mkdir -p gf
    for p in $(gf -list); do
        tmp="$(mktemp)"
        gf "$p" "$file" > "$tmp" 2>/dev/null || true
        [ -s "$tmp" ] && mv "$tmp" "gf/${p}.txt" || rm -f "$tmp"
    done
}

mk_js() {
    mkdir -p js
    grep -iE '\.js($|\?)' urls-all.txt | sort -u > js/all-js.txt
}

scan_jsleak() {
    mkdir -p js
    grep -iE '\.js($|\?)' urls-all.txt | sort -u > js/all-js.txt
    [ -s js/all-js.txt ] && jsleak -l -s < js/all-js.txt > js/jsleak-findings.txt 2>/dev/null || true
}

domain="$1"
workdir="./$domain"

mkdir -p "$workdir" "$workdir/logs"
trap 'rm -rf "$workdir"' EXIT

dig +short "$domain" >/dev/null || exit 1

findomain -t "$domain" -u "$workdir/findomain.txt" 2>"$workdir/logs/findomain.log" &
subfinder -d "$domain" -silent -all -recursive -o "$workdir/subfinder.txt" 2>"$workdir/logs/subfinder.log" &
assetfinder -subs-only "$domain" > "$workdir/assetfinder.txt" 2>"$workdir/logs/assetfinder.log" &
wait

sort -u "$workdir"/*.txt > "$workdir/subdomains.txt"

httpx -l "$workdir/subdomains.txt" -mc 404 -silent | cut -d ' ' -f1 > "$workdir/subdomains_404.txt" 2>"$workdir/logs/httpx404.log" &
httpx -l "$workdir/subdomains.txt" -mc 403 -silent | cut -d ' ' -f1 > "$workdir/subdomains_403.txt" 2>"$workdir/logs/httpx403.log" &
httpx -l "$workdir/subdomains.txt" -ports 80,443,8080,8000,8888 -threads 200 -timeout 5 -retries 3 -silent > "$workdir/livesubdomains.txt" 2>"$workdir/logs/httpx_live.log" &
wait

dirsearch \
    --exclude-status=404 \
    -w ~/tools/ultimate_discovery/ultimate-discovery.txt \
    -l "$workdir/subdomains_404.txt" \
    -t 250 \
    -o "$workdir/results_404.txt" \
    2>"$workdir/logs/dirsearch.log" &

katana -u "$workdir/livesubdomains.txt" -d 2 -silent -o "$workdir/urls-katana.txt" 2>"$workdir/logs/katana.log" &
waybackurls "$domain" | sort -u > "$workdir/urls-wayback.txt" 2>"$workdir/logs/wayback.log" &
gau "$domain" | sort -u > "$workdir/urls-gau.txt" 2>"$workdir/logs/gau.log" &
urlfinder -d "$domain" | sort -u > "$workdir/urls-urlfinder.txt" 2>"$workdir/logs/urlfinder.log" &
wait

cat "$workdir"/urls-*.txt | sort -u > "$workdir/urls-all.txt"

cd "$workdir"
gfcat
mk_js
scan_jsleak
