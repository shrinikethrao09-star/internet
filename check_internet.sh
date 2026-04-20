#!/bin/bash

PING_TARGET="8.8.8.8"
ROUTER_IP="192.168.1.1"

FAIL_COUNT_FILE="/tmp/fail_count"
LOCKFILE="/tmp/internet_check.lock"
LOGFILE="/home/sh/internet/router_check.log"

ROUTER_DELAY=30
RPI_DELAY=60
MAX_FAIL=3

# 🔒 Prevent multiple runs
if [ -f "$LOCKFILE" ]; then
    echo "$(date): Script already running, exiting..." >> $LOGFILE
    exit 1
fi

touch $LOCKFILE
trap "rm -f $LOCKFILE" EXIT

# Read fail count
COUNT=$(cat $FAIL_COUNT_FILE 2>/dev/null || echo 0)

# 🌐 Check internet
if ! ping -c 3 $PING_TARGET > /dev/null; then
    COUNT=$((COUNT+1))
    echo $COUNT > $FAIL_COUNT_FILE
    echo "$(date): Internet FAIL ($COUNT)" >> $LOGFILE

    # 🚨 Trigger reboot after max failures
    if [ "$COUNT" -ge "$MAX_FAIL" ]; then

        # Reset count immediately (IMPORTANT)
        echo 0 > $FAIL_COUNT_FILE

        echo "$(date): Router will reboot in $ROUTER_DELAY seconds..." >> $LOGFILE
        sleep $ROUTER_DELAY

        # 🔄 Reboot router
        ssh -o ConnectTimeout=5 root@$ROUTER_IP reboot

        echo "$(date): Raspberry Pi will reboot in $RPI_DELAY seconds..." >> $LOGFILE
        sleep $RPI_DELAY

        echo "$(date): Triggering Raspberry Pi reboot..." >> $LOGFILE

        # 🔄 Reboot Raspberry Pi (safe background)
        nohup sudo /sbin/reboot >/dev/null 2>&1 &
    fi

else
    echo "$(date): Internet OK" >> $LOGFILE
    echo 0 > $FAIL_COUNT_FILE
fi
