#!/bin/bash

info() { echo "I: $@"; }; error() { echo "E: $@";exit 1; }

if [ $(id -u) -ne 0 ]; then

  # inatall deps
  
  info "exec in user"
  
  missing=""

  [ -x "$(command -v ar)" ] || missing="binutils"
  [ -x "$(command -v perl)" ] || missing="perl $missing"
  [ -x "$(command -v wget)" ] || missing="wget $missing"
  [ -x "$(command -v tsu)" ] || missing="tsu $missing"
  
  [ -z "$missing" ] || pkg install -y $missing || error "install deps failed"
  
  exec sudo bash $(realpath $0) $@ || error "su failed"

fi

info "exec in root"

if [ "$LD_PRELOAD" != "/data/data/com.termux/files/usr/lib/libtermux-exec.so" ]; then

  # switch into termux
  
  info "switch into termux"

  termuxEnv="env \
    HOME=/data/data/com.termux/files/home \
    PREFIX=/data/data/com.termux/files/usr \
    PWD=/data/data/com.termux/files/home \
    LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec.so \
    LANG=en_US.UTF-8  \
    TMPDIR=/data/data/com.termux/files/usr/tmp \
    PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets"
  
  echo $0
  
  exec su -m -c "$termuxEnv bash $0 \"$@\""

fi

if [ -z "${ENV_DIR}" ]; then

  ENV_DIR=$(realpath "$0")
  ENV_DIR="${ENV_DIR%/*}"
  
fi

[ -f "$ENV_DIR/cli.sh" ] || error "cannot read ENV_DIR."

[ $2 ] || error "ldt <profile> <action...>"

PROFILE="$1"

shift 1;

config_file="${ENV_DIR}/config/${PROFILE}.conf"

[ -e "$config_file" ] || error "profile ${PROFILE} not exists."

CHROOT_DIR="/mnt/chroot/${PROFILE}"

if [ $1 = "login" ]; then
  
  . "$config_file"
  
  $0 "$PROFILE" shell /usr/bin/env -i \
    HOME=/root \
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games \
    TERM="$TERM" \
    LANG="$LOCALE" \
    /bin/bash --login
  
  $0 "$PROFILE" umount
  
else 

  PATH="$PATH" \
    ENV_DIR="$ENV_DIR" \
    PROFILE="$PROFILE" \
    CHROOT_DIR="$CHROOT_DIR" \
    ${ENV_DIR}/cli.sh $@
    
fi