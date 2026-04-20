#!/bin/bash

PING_TARGET="8.8.8.8"
LOGFILE="/home/sh/internet/router_check.log"

# 🌐 Check internet (10 pings)
if ! ping -c 10 $PING_TARGET > /dev/null; then
    echo "$(date): Internet FAIL (triggering reboot)" >> $LOGFILE

    echo "$(date): Rebooting router in 30 seconds..." >> $LOGFILE
    sleep 30

    ssh -o ConnectTimeout=5 root@192.168.1.1 reboot

else
    echo "$(date): Internet OK" >> $LOGFILE
fi
