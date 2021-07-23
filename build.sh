#!/bin/bash


project_root="$(realpath `dirname $?`)"


case "$1" in
  "awesome:docker")
    docker build --network host --tag foo/awesome:dom0 "$project_root"
    ;;

  "awesome:dom0")
    installroot="${project_root}/qubes-builder/chroot-dom0-fc25"
    sudo dnf install --assumeyes --installroot="$installroot" ${deps[@]}
    ;;

  *)
    echo "options: awesome:docker | awesome:dom0"
    ;;
esac
