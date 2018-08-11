#!/usr/bin/env bash

# create our hab group
sudo groupadd hab
# create our hab user, could probably just do this all in one command...
sudo useradd -g hab hab

# this really is bad practice...
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo TMPDIR=/root bash # we assume there's noexec on /tmp and /var/tmp

# Create our systemd unit file
cat<<EOF | sudo tee /etc/systemd/system/hab.service
[Unit]
Description=The Habitat Supervisor

[Service]
ExecStart=/bin/hab sup run --no-color

[Install]
WantedBy=default.target
EOF

# start the habitat daemon
systemctl start hab

# wait for hab sup to come up
until sudo hab svc status; do sleep 1; done

# install Factorio package
sudo hab pkg install maraaaa/factorio

# Start Factorio server
sudo hab svc load maraaaa/factorio
