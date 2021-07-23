#!/bin/bash

set -e

project_root="$(realpath `dirname $?`)"

case "$1" in
  "deps:host")
    # for x11docker
    sudo dnf install --assumeyes \
      bash \
      docker \
      xclip \
      xpra \
      xorg-x11-server-utils \
      xorg-x11-server-Xephyr \
      xorg-x11-utils \
      xorg-x11-xinit \
      xorg-x11-xauth
    ;;

  "deps:qubes-builder")
		# TODO: pull qubes-builder
    # install qubes-builder deps
    sudo dnf install --assumeyes \
      git \
      make
      # createrepo \
      # devscripts \
      # dialog \
      # gnupg \
      # python3-sh \
      # rpmdevtools \
      # rpm-build \
      # rpm-sign \
      # wget \
      # perl-Digest-MD5 \
      # perl-Digest-SHA \
      # python3-pyyaml
    
    # gpg --keyserver https://pgp.mit.edu --recv-keys 0xDDFA1A3E36879494

    # curl --silent  https://keys.qubes-os.org/keys/qubes-developers-keys.asc > /tmp/qubes-developers-keys.asc
    # gpg --import /tmp/qubes-developers-keys.asc


    if ! [[ -d "qubes-builder/.git" ]]; then
      git clone git://github.com/QubesOS/qubes-builder.git "qubes-builder"
    else
      cd "qubes-builder"
      git pull --force
    fi

    cd $project_root
    cp builder.conf qubes-builder/

    cd qubes-builder
    make install-deps
    make get-sources
    make prepare-chroot-dom0

    # cd qubes-builder
    # git tag -v `git describe`

    exit
    # install awesomewm deps in chroot
    installroot="${project_root}/qubes-builder/chroot-dom0-fc25"
    sudo dnf install --assumeyes --installroot="$installroot" \
      cairo-devel \
      cmake \
      dbus-devel \
      gdk-pixbuf2-devel \
      glib-devel \
      libxdg-basedir-devel \
      libxkbcommon-devel \
      libxkbcommon-x11-devel \
      luajit-devel \
      rpmbuild \
      startup-notification-devel \
      xcb-util-cursor-devel \
      xcb-util-devel \
      xcb-util-keysyms-devel \
      xcb-util-wm-devel \
      xcb-util-xrm-devel
    ;;

  *)
    echo "options: deps:host | deps:qubes-builder"
    ;;
esac
