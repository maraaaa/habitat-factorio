pkg_name=factorio
pkg_origin=maraaaa
pkg_version="0.16.51"
pkg_license=("MIT")
pkg_description="Package to run Factorio headless server 'Anywhere'^tm"
pkg_upstream_url="https://github.com/maraaaa/habitat-factorio"
pkg_filename="${pkg_name}-${pkg_version}_linux_amd64.tar.xz"
pkg_source="https://www.factorio.com/get-download/${pkg_version}/headless/linux64"
pkg_shasum="6cb09f5ac87f16f8d5b43cef26c0ae26cc46a57a0382e253dfda032dc5bb367f"
pkg_deps=(core/glibc core/bash)
pkg_build_deps=(core/patchelf)
pkg_bin_dirs=(bin/x64)
pkg_exports=(port)

pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"

# skip ./configre && make step
do_build() {
  return 0
}

do_install() {
  # copy our binary and data directory to our pkg_prefix path
  cp -r ${HAB_CACHE_SRC_PATH}/factorio/{bin,data} ${pkg_prefix}
  patchelf --interpreter "$(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2" ${pkg_prefix}/bin/x64/factorio
  # there's GOT to be a better way to do this, but the factorio binary expects config-path.cfg 
  # to exist at ../../config-path.cfg relative to the executable... this does not appear to be configurable.
  echo "config-path=/hab/svc/factorio/config" | tee ${pkg_prefix}/config-path.cfg
  echo "use-system-read-write-data-directories=false" | tee -a ${pkg_prefix}/config-path.cfg
}
