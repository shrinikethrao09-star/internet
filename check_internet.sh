#!/bin/bash

URL="http://clients3.google.com/generate_204"
LOGFILE="/home/sh/internet/router_check.log"

if wget -q -O /dev/null --timeout=60 $URL; then
    echo "$(date): Internet OK" >> $LOGFILE
else
    echo "$(date): Internet FAIL (triggering reboot)" >> $LOGFILE
    sleep 30
    ssh -o ConnectTimeout=60 root@192.168.1.1 reboot
fi
