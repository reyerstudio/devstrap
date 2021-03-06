#!/usr/bin/env bash
local ACTION=$1
local WSTORM_VERSION="2016.1.2"

WEBSTORM_RA_INIT_UBUNTU='# IDEA 78860 - https://youtrack.jetbrains.com/issue/IDEA-78860
export IBUS_ENABLE_SYNC_MODE=1'

function strapping() {
  echo "Strapping webstorm..."
  case "$DISTRIB" in
    "osx")
      if [ ! -f /usr/local/bin/wstorm ]; then
        download WebStorm-${WSTORM_VERSION}.dmg https://download.jetbrains.com/webstorm/WebStorm-${WSTORM_VERSION}.dmg
        FILE=$RET
        open $FILE -W
        rm "$FILE"
      fi
      ;;
    "debian"|"ubuntu")
      if [ ! -f /usr/local/bin/wstorm ]; then
        download WebStorm-${WSTORM_VERSION}.tar.gz https://download.jetbrains.com/webstorm/WebStorm-${WSTORM_VERSION}.tar.gz
        FILE=$RET
        sudo rm -rf /opt/webstorm
        sudo mkdir -p /opt
        sudo tar xzf "$FILE" -C /opt
        sudo mv /opt/WebStorm-* /opt/webstorm
        /opt/webstorm/bin/webstorm.sh
        rm "$FILE"
      fi
      install_ra_init webstorm "$WEBSTORM_RA_INIT_UBUNTU"
      ;;
    *)
      echo "$DISTRIB not supported"
      ;;
  esac
}

function unstrapping() {
  echo "Unstrapping webstorm..."
  case "$DISTRIB" in
    "osx")
      rm -rf /Applications/WebStorm.app
      rm -f /usr/local/bin/wstorm
      rm -rf ~/.WebStorm$(echo $WSTORM_VERSION | cut -d'.' -f1)
      ;;
    "debian"|"ubuntu")
      sudo rm -rf /opt/webstorm
      sudo rm -f /usr/local/bin/wstorm
      rm -rf ~/.WebStorm$(echo $WSTORM_VERSION | cut -d'.' -f1)
      uninstall_ra_init webstorm
      ;;
    *)
      echo "$DISTRIB not supported"
      ;;
  esac
}

$ACTION
