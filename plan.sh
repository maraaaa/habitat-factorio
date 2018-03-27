pkg_name=factorio
pkg_origin=maraaaa
pkg_version="0.1.0"
# pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("MIT")

# would be cool to be able to override this, but then we need the shasum too
factorio_version="0.16.35"
pkg_source="https://www.factorio.com/get-download/${factorio_version}/headless/linux64"

# The resulting filename for the download, typically constructed from the
# pkg_name and pkg_version values.
pkg_filename="${pkg_name}-${pkg_version}_linux_amd64.tar.xz"

# Required if a valid URL is provided for pkg_source or unless do_verify() is overridden.
pkg_shasum="1075945be0be4ab192c424e665f89f4145e669db4a9345c7f6b1d2a0b68f9574"

# Optional.
# An array of package dependencies needed at runtime. You can refer to packages
# at three levels of specificity: `origin/package`, `origin/package/version`, or
# `origin/package/version/release`.
pkg_deps=(core/glibc)
pkg_build_deps=()
pkg_bin_dirs=(bin/x64)

# Optional.
# The command for the Supervisor to execute when starting a service. You can
# omit this setting if your package is not intended to be run directly by a
# Supervisor of if your plan contains a run hook in hooks/run.
# pkg_svc_run="factorio --start-server --server-settings $pkg_svc_config_path/server-settings.conf "
pkg_svc_run="factorio --start-server --help"
# --start-server saves/2018-03-24-0201-making-speed-module-I.zip --executable-path ./bin/x64/factorio --server-settings data/server-settings.json


# Optional.
# An associative array representing configuration data which should be gossiped to peers. The keys
# in this array represent the name the value will be assigned and the values represent the toml path
# to read the value.
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )


# Optional.
# An array of `pkg_exports` keys containing default values for which ports that this package
# exposes. These values are used as sensible defaults for other tools. For example, when exporting
# a package to a container format.
# pkg_exposes=(port)


# Optional.
# An associative array representing services which you depend on and the configuration keys that
# you expect the service to export (by their `pkg_exports`). These binds *must* be set for the
# Supervisor to load the service. The loaded service will wait to run until it's bind becomes
# available. If the bind does not contain the expected keys, the service will not start
# successfully.
# pkg_binds=(
#   [database]="port host"
# )


# Optional.
# Same as `pkg_binds` but these represent optional services to connect to.
# pkg_binds_optional=(
#   [storage]="port host"
# )


# Optional.
# An array of interpreters used in shebang lines for scripts. Specify the
# subdirectory where the binary is relative to the package, for example,
# bin/bash or libexec/neverland, since binaries can be located in directories
# besides bin. This list of interpreters will be written to the metadata
# INTERPRETERS file, located inside a package, with their fully-qualified path.
# Then these can be used with the fix_interpreter function.
# pkg_interpreters=(bin/bash)


# Optional.
# The user to run the service as. The default is hab.
pkg_svc_user="hab"


# Optional.
# The group to run the service as. The default is hab.
# pkg_svc_group="$pkg_svc_user"


# Required for core plans, optional otherwise.
# A short description of the package. It can be a simple string, or you can
# create a multi-line description using markdown to provide a rich description
# of your package.
pkg_description="Package to run Factorio headless server 'Anywhere'^tm"


# Required for core plans, optional otherwise.
# The project home page for the package.
# pkg_upstream_url="http://example.com/project-name"


# Callback Functions
#
# When defining your plan, you have the flexibility to override the default
# behavior of Habitat in each part of the package building stage through a
# series of callbacks. To define a callback, simply create a shell function
# of the same name in your plan.sh file and then write your script. If you do
# not want to use the default callback behavior, you must override the callback
# and return 0 in the function definition.
#
# Callbacks are defined here with either their "do_default_x", if they have a
# default implementation, or empty with "return 0" if they have no default
# implementation (Bash does not allow empty function bodies.) If callbacks do
# nothing or do the same as the default implementation, they can be removed from
# this template.
#
# The default implementations (the do_default_* functions) are defined in the
# plan build script:
# https://github.com/habitat-sh/habitat/tree/master/components/plan-build/bin/hab-plan-build.sh

# There is no default implementation of this callback. You can use it to execute
# any arbitrary commands before anything else happens.
do_begin() {
  return 0
}

# The default implementation is that the software specified in $pkg_source is
# downloaded, checksum-verified, and placed in $HAB_CACHE_SRC_PATH/$pkgfilename,
# which resolves to a path like /hab/cache/src/filename.tar.gz. You should
# override this behavior if you need to change how your binary source is
# downloaded, if you are not downloading any source code at all, or if your are
# cloning from git. If you do clone a repo from git, you must override
# do_verify() to return 0.
do_download() {
  do_default_download
}

# The default implementation tries to verify the checksum specified in the plan
# against the computed checksum after downloading the source tarball to disk.
# If the specified checksum doesn't match the computed checksum, then an error
# and a message specifying the mismatch will be printed to stderr. You should
# not need to override this behavior unless your package does not download
# any files.
do_verify() {
  do_default_verify
}

# The default implementation removes the HAB_CACHE_SRC_PATH/$pkg_dirname folder
# in case there was a previously-built version of your package installed on
# disk. This ensures you start with a clean build environment.
do_clean() {
  do_default_clean
}

# The default implementation extracts your tarball source file into
# HAB_CACHE_SRC_PATH. The supported archives are: .tar, .tar.bz2, .tar.gz,
# .tar.xz, .rar, .zip, .Z, .7z. If the file archive could not be found or was
# not supported, then a message will be printed to stderr with additional
# information.
do_unpack() {
  echo "in do_unpack"
  echo "pwd: $(pwd)"
  echo "HAB_CACHE_SRC_PATH: ${HAB_CACHE_SRC_PATH}"
  # cd "${HAB_CACHE_SRC_PATH}" || exit
  # mkdir -v ${HAB_CACHE_SRC_PATH}/${pkg_name}-${pkg_version}
  # tar xf ${pkg_filename} --strip-components=1 -C "${pkg_name}-${pkg_version}"
  do_default_unpack
}

# There is no default implementation of this callback. At this point in the
# build process, the tarball source has been downloaded, unpacked, and the build
# environment variables have been set, so you can use this callback to perform
# any actions before the package starts building, such as exporting variables,
# adding symlinks, and so on.
do_prepare() {
  return 0
}

# The default implementation is to update the prefix path for the configure
# script to use $pkg_prefix and then run make to compile the downloaded source.
# This means the script in the default implementation does
# ./configure --prefix=$pkg_prefix && make. You should override this behavior
# if you have additional configuration changes to make or other software to
# build and install as part of building your package.
do_build() {
  return 0
  # do_default_build
}

# The default implementation runs nothing during post-compile. An example of a
# command you might use in this callback is make test. To use this callback, two
# conditions must be true. A) do_check() function has been declared, B) DO_CHECK
# environment variable exists and set to true, env DO_CHECK=true.
do_check() {
  return 0
}

# The default implementation is to run make install on the source files and
# place the compiled binaries or libraries in HAB_CACHE_SRC_PATH/$pkg_dirname,
# which resolves to a path like /hab/cache/src/packagename-version/. It uses
# this location because of do_build() using the --prefix option when calling the
# configure script. You should override this behavior if you need to perform
# custom installation steps, such as copying files from HAB_CACHE_SRC_PATH to
# specific directories in your package, or installing pre-built binaries into
# your package.
do_install() {
  echo "in do_install()"
  echo "pkg_prefix: ${pkg_prefix}"
  echo "HAB_CACHE_SRC_PATH: ${HAB_CACHE_SRC_PATH}"
  echo "ls ${HAB_CACHE_SRC_PATH}: $(ls ${HAB_CACHE_SRC_PATH})"
  echo "pwd: $(pwd)"
  cp -vr ${HAB_CACHE_SRC_PATH}/factorio/{bin,config-path.cfg,data} ${pkg_prefix}
  # install -D ${HAB_CACHE_SRC_PATH}/factorio/bin/x64/factorio "${pkg_prefix}/bin/x64/factorio"
  # do_default_install
}

# The default implementation is to strip any binaries in $pkg_prefix of their
# debugging symbols. You should override this behavior if you want to change
# how the binaries are stripped, which additional binaries located in
# subdirectories might also need to be stripped, or whether you do not want the
# binaries stripped at all.
do_strip() {
  do_default_strip
}

# There is no default implementation of this callback. This is called after the
# package has been built and installed. You can use this callback to remove any
# temporary files or perform other post-install clean-up actions.
do_end() {
  return 0
}

