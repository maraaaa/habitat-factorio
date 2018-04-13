# Habitat package: factorio

## Description

This was largely inspired by issues arising from running factorio on [Older Versions of CentOS](https://forums.factorio.com/viewtopic.php?f=49&t=54619), which [required compiling glibc](https://forums.factorio.com/viewtopic.php?p=324493&sid=0d99fb88ebf1d28ea6f7fe33cfc1b5b9#p324493) and running it with a mess of options:

```
/opt/glibc-2.18/lib/ld-linux-x86-64.so.2 --library-path /opt/glibc-2.18/lib:/lib64 /opt/factorio/bin/x64/factorio --start-server saves/my-map.zip --executable-path ./bin/x64/factorio --server-settings data/server-settings.json
```

Enter Habitat!  Habitat allows us to bundle the application dependencies with the application and then download, install, and run them as a single uint.  Selfishly, this project was chosen as a way to learn Habitat and a way to mess around with Factorio at work (this is just as "relevant" to work as the demo node app...).  As this is a learning tool, this project should largely be considered a work in progress!

Next, to figure out how that config.ini file is generated...  Then to provide a server-config.json!

## Usage

### Setup:

```
sudo groupadd hab
sudo useradd -g hab hab
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo TMPDIR=/root bash # we assume there's noexec on /tmp and /var/tmp
sudo hab pkg install maraaaa/factorio
sudo hab pkg exec maraaaa/factorio factorio --create /hab/svc/factorio/data/start # Unfortunately, this is hardcoded at the moment
```

### Using own maps:

You can copy your own map to `/hab/svc/factorio/data/start.zip` (the name is important!) after running the above create command.

### Starting Service

#### Using Habitat supervisor

If you want to run factorio in the forground (for instance, for debugging purposes) omit the `hab sup run` step.

```
sudo hab sup run
sudo hab svc start maraaaa/factorio
```

#### Using the factorio binary directly:

```
sudo hab pkg exec maraaaa/factorio factorio --start-server /path/to/save.zip <other options>
```

This will cause factorio to run as if you had invoked `bin/x64/factorio` directly, but will leverage the 

#### Running as a system service

Create a startup file.  For instance, for systemd, create `/etc/systemd/system/factorio.service`:

```
[Unit]
Description=The Habitat Supervisor

[Service]
ExecStart=/bin/hab sup run

[Install]
WantedBy=default.target
```

The start and enable the service:

```
systemctl enable habitat
systemctl start habitat
```

(this assumes you have run `sudo hab svc start maraaa/factorio` previously.  If you have not, do so now)

### Configuring

All options in config.ini can be set in the "standard" habitat manner, detailed instructions [can be found on the Habitat website](https://www.habitat.sh/docs/using-habitat/#config-updates).  Refer to the default.toml or config.ini for full list of option names.

Though untested, my interpretation of the docs means that:

```
$ HAB_FACTORIO='{"autosave-slots"="10"}' hab start maraaaa/factorio
```

or 

create a user.toml file at `/hab/user/factorio/config/user.toml` with any desired options, e.g.:

```
sudo mkdir -p /hab/user/factorio/config
cat <<EOF | sudo tee /hab/user/factorio/config/user.toml
autosave-slots="10"
autosave-compression-level="maximum"
EOF

```

(these examples were chosen at random)

### Uninstalling

```
sudo rm -rf /hab/pkgs/maraaaa/factorio/ # to remove the package binaries
sudo rm -rf /hab/svc/factorio/ 		# to remove any settings/saves/etc
```

If you want to retain settings, you should run only the first command.

### Upgrading


### Templating

The following were used to convert the config.ini to default.toml and templatized config.ini

```
perl -pi -e 's/^\n$//' config/config.ini.org
perl -p -e 's/(?:; )?([a-z-]+)=([a-z0-9.-]+)?/\1="\2"/; s/;\s?\n//; s/;/#/; s/\[/# [/' config/config.ini  >> default.toml
perl -n -e 'next if m/; (Options|Alpha)/; s/(?:; )?([a-z-]+)=([a-z0-9.-]+)?/\1={{cfg\.\1}}/; print' config/config.ini.org > config/config.ini
```


