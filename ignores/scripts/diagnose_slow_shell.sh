#!/bin/bash
# diagnose_slow_shell.sh
# A script to detect possible causes of shell slowness

echo "=== Starting diagnostics ==="
echo

# 1. Measure basic command execution time
echo "[1] Timing simple commands..."
for cmd in "echo test" "ls /" "ls /home"; do
    echo -n "Command '$cmd': "
    TIMEFORMAT="%3R seconds"
    time $cmd
done
echo

# 2. Check recent USB errors
echo "[2] Checking USB errors in dmesg..."
dmesg | tail -n 20 | grep -i usb || echo "No recent USB errors detected."
echo

# 3. Check disk I/O activity
echo "[3] Checking disk I/O (iotop 3 seconds snapshot)..."
if command -v iotop &>/dev/null; then
    sudo iotop -b -n 3 | head -n 20
else
    echo "iotop not installed. Skipping disk I/O check."
fi
echo

# 4. Check shell prompt speed (without plugins)
echo "[4] Testing plain shell startup time..."
START=$(date +%s%N)
bash --noprofile --norc -c "echo 'Hello from minimal shell'"
END=$(date +%s%N)
ELAPSE=$(( (END-START)/1000000 ))
echo "Minimal shell startup: $ELAPSE ms"
echo

# 5. Check CPU usage of background VMs or processes
echo "[5] Top 5 CPU consumers:"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
echo

echo "=== Diagnostics complete ==="
echo "Interpretation hints:"
echo "- If USB errors appear repeatedly, unplug or disable the device."
echo "- If plain shell is fast, your usual prompt or plugins may be slow."
echo "- High disk I/O or CPU can indicate VMs or heavy processes."

