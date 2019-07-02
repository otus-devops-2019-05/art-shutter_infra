#!/bin/bash

cat > /etc/systemd/system/puma.service <<EOF
[Unit]
Description=Puma server unit file
After=network.target

[Service]
User=artem
Group=artem
Type=simple
WorkingDirectory=/home/artem/reddit
ExecStart=/usr/local/bin/puma
TimeoutSec=300

[Install]
WantedBy=multi-user.target

EOF

chmod 644 /etc/systemd/system/puma.service
systemd daemon-reload
systemd start puma.service 2>&1 | tee -a $log
sleep 2
systemd status puma.service 2>&1 | tee -a $log
ps aux | grep puma | tee -a $log
systemd enable puma 2>&1 | tee -a $log