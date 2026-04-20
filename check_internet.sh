#!/bin/bash

PING_TARGET="8.8.8.8"
FAIL_COUNT_FILE="/tmp/fail_count"
LOGFILE="/home/sh/internet/router_check.log"

COUNT=$(cat $FAIL_COUNT_FILE 2>/dev/null || echo 0)

if ! ping -c 3 $PING_TARGET > /dev/null; then
    COUNT=$((COUNT+1))
    
    # 🚫 Limit max count to 3
    [ "$COUNT" -gt 3 ] && COUNT=3

    echo $COUNT > $FAIL_COUNT_FILE
    echo "$(date): Internet FAIL ($COUNT)" >> $LOGFILE

    if [ "$COUNT" -eq 3 ]; then
        echo "$(date): Rebooting router in 30 seconds..." >> $LOGFILE
        
        sleep 30
        
        ssh -o ConnectTimeout=5 root@192.168.1.1 reboot
        
        # Reset after action
        echo 0 > $FAIL_COUNT_FILE
    fi
else
    echo "$(date): Internet OK" >> $LOGFILE
    echo 0 > $FAIL_COUNT_FILE
fi
