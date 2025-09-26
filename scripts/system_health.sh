#!/usr/bin/env bash
# system_health.sh
# Usage: ./system_health.sh > /var/log/system_health.log

LOGFILE="${1:-./system_health.log}"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85

timestamp() { date '+%F %T'; }

echo "=== $(timestamp) ===" >> "$LOGFILE"

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
MEM=$(free | awk '/Mem:/ { printf("%.0f", $3/$2 * 100) }')
DISK=$(df -h / | awk 'NR==2 {print int($5)}')
PROCS=$(ps aux --no-heading | wc -l)

echo "CPU%: $CPU  MEM%: $MEM  DISK%: $DISK  PROCS: $PROCS" >> "$LOGFILE"

if [ "$CPU" -ge "$CPU_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: CPU usage $CPU% >= ${CPU_THRESHOLD}% " >> "$LOGFILE"
fi
if [ "$MEM" -ge "$MEM_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: Memory usage $MEM% >= ${MEM_THRESHOLD}% " >> "$LOGFILE"
fi
if [ "$DISK" -ge "$DISK_THRESHOLD" ]; then
  echo "$(timestamp) ALERT: Disk usage $DISK% >= ${DISK_THRESHOLD}% " >> "$LOGFILE"
fi

