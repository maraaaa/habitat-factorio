pkg_name=factorio
pkg_origin=maraaaa
pkg_version="0.16.36"
pkg_license=("MIT")

# Project Info
pkg_description="Package to run Factorio headless server 'Anywhere'^tm"
pkg_upstream_url="https://github.com/maraaaa/habitat-factorio"

# Package Data
pkg_filename="${pkg_name}-${pkg_version}_linux_amd64.tar.xz"
pkg_source="https://www.factorio.com/get-download/${pkg_version}/headless/linux64"
# Required!
pkg_shasum="047ff44204876c54835cfc76dedca6809dd6aee48a16efbd5eb305e294415258"

# Deps
pkg_deps=(core/glibc)
pkg_build_deps=(core/tar)
pkg_bin_dirs=(bin/x64)

# run our service
pkg_svc_run="factorio --start-server data/start.zip --server-settings config/server-settings.json"

# This never works... always
# TODO: make exports work.
# pkg_exports=([factorio_port]=port)
# pkg_exports=([port]=port)
# pkg_exposes=(port)
pkg_exports=(port)

pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"

# Callback Functions
#
# The default implementations (the do_default_* functions) are defined in the
# plan build script:
# https://github.com/habitat-sh/habitat/tree/master/components/plan-build/bin/hab-plan-build.sh

# since we're downloading a binary, skip the ./configre && make step
do_build() {
  return 0
}

# Since we're just copying our binary to the package path, override the default
do_install() {
  # copy our binary and data directory to our pkg_prefix path
  cp -r ${HAB_CACHE_SRC_PATH}/factorio/{bin,data} ${pkg_prefix}
  # there's GOT to be a better way to do this, but the factorio binary expects config-path.cfg 
  # to exist at ../../config-path.cfg relative to the executable... this does not appear to be configurable.
  echo "config-path=/hab/svc/factorio/config" | tee ${pkg_prefix}/config-path.cfg
  echo "use-system-read-write-data-directories=false" | tee -a ${pkg_prefix}/config-path.cfg
}
