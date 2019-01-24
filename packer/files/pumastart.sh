#!/bin/bash
cat <<EOF> /etc/systemd/system/puma.service
[Unit]
Description=Puma Server
After=network.target

[Service]
Type=simple#
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc "/usr/local/bin/puma -C /home/appuser/reddit/config/deploy/production.rb"
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable puma
systemctl start puma

