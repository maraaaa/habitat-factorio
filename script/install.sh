sudo groupadd hab
sudo useradd -g hab hab
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo TMPDIR=/root bash # we assume there's noexec on /tmp and /var/tmp
sudo hab pkg install maraaaa/factorio
sudo hab pkg exec maraaaa/factorio factorio --create /hab/svc/factorio/data/start # Unfortunately, this is hardcoded at the moment
sudo hab svc start maraaaa/factorio
