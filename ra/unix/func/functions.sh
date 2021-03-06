DEVSTRAP=$DEVSTRAP_NAME
[ -z "$DEVSTRAP" ] && DEVSTRAP="devstrap"
DEVSTRAP_HOME="$HOME/$DEVSTRAP"
DEVSTRAP_RA_PROFILE="$HOME/.$DEVSTRAP/ra/profile.d"
DEVSTRAP_RA_LIBEXEC="$HOME/.$DEVSTRAP/ra/libexec"
DEVSTRAP_SSH_CONFIG="$HOME/.$DEVSTRAP/ssh/config.d"
DEVSTRAP_SSH_HOSTS="$HOME/.$DEVSTRAP/ssh/known_hosts.d"

function commands() {
  find $LIBEXECDIR -name "*.sh" | $_XARGS basename -s ".sh"
  if [ -d "$DEVSTRAP_RA_LIBEXEC" ] ; then
    find $DEVSTRAP_RA_LIBEXEC -name "*.sh" | $_XARGS basename -s ".sh"
  fi
}

function launch() {
  local CMD=$1
  shift
  if [ -f "$LIBEXECDIR/$CMD.sh" ]; then
    source "$LIBEXECDIR/$CMD.sh" "$@"
  fi
  if [ -f "$DEVSTRAP_RA_LIBEXEC/$CMD.sh" ]; then
    source "$DEVSTRAP_RA_LIBEXEC/$CMD.sh" "$@"
  fi
}

function add_to_path() {
  local DIR=$1
  if [[ "$PATH" =~ (^|:)"$DIR"(:|$) ]]; then
    return 0
  fi
  export PATH=$DIR:$PATH
}

function remove_from_path() {
  local DIR=$1
  PATH=$(echo $PATH | sed -e 's;:\?$DIR;;' -e 's;$DIR:\?');
}

function brew_install_or_upgrade() {
  echo "Install or upgrade $1"
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      brew upgrade "$@"
    fi
  else
    brew install "$@"
  fi
}

function brew_is_installed() {
  local name="$(brew_expand_alias "$1")"

  brew list -1 | grep -Fqx "$name"
}

function brew_is_upgradable() {
  local name="$(brew_expand_alias "$1")"

  brew outdated --quiet "$name" >/dev/null
  [[ $? -ne 0 ]]
}

function brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

function npm_install_or_upgrade() {
  echo "Install or upgrade $1"
  if npm_is_installed "$1"; then
    if npm_is_upgradable "$1"; then
      $_NPM update -g "$@"
    fi
  else
    $_NPM install -g "$@"
  fi
}

function npm_is_installed() {
  local name="$1"

  npm -j list -g --depth=0 $name > /dev/null
}

function npm_is_upgradable() {
  local name="$1"

  npm -j outdated -g "$name" > /dev/null
  [[ $? -ne 0 ]]
}

function strap_action() {
  local ACTION=$1
  local URL=$2
  local TARGET=$3
  local REMOTE=""
  if [ -z "$TARGET" ]; then
    echo "ERROR: Missing 'target' module"
    exit 1
  else
    FILE="$TARGET"
    if [[ ! "$FILE" =~ \.sh$ ]]; then
      FILE="$FILE.sh"
    fi

    if [ -f "$FILE" ]; then
      echo "Executing local $FILE"
    else
      echo "Downloading $URL/straps/unix/$TARGET.sh"
      FILE="/tmp/$TARGET.sh"
      rm -f "$FILE"
      REMOTE="$URL/straps/unix/$TARGET.sh"
      curl -sL $REMOTE > "$FILE"
    fi
    source "$FILE" $ACTION
    [ ! -z "$REMOTE" ] && rm -f "$FILE"
  fi
}

function install_ra_cmd() {
  local NAME=$1
  local SCRIPT=$2
  mkdir -p "$DEVSTRAP_RA_LIBEXEC"
  echo "$SCRIPT" > "$DEVSTRAP_RA_LIBEXEC/$NAME.sh"
}

function uninstall_ra_cmd() {
  local NAME=$1
  rm -f "$DEVSTRAP_RA_LIBEXEC/$NAME.sh"
}

function install_ra_init() {
  local NAME=$1
  local SCRIPT=$2
  mkdir -p "$DEVSTRAP_RA_PROFILE"
  echo "$SCRIPT" > "$DEVSTRAP_RA_PROFILE/$NAME.sh"
  # Enable it in the current session
  source "$DEVSTRAP_RA_PROFILE/$NAME.sh"
}

function uninstall_ra_init() {
  local NAME=$1
  rm -f "$DEVSTRAP_RA_PROFILE/$NAME.sh"
}

function install_ssh_config() {
  local NAME=$1
  local CONFIG=$2
  mkdir -p "$DEVSTRAP_SSH_CONFIG"
  echo "$CONFIG" > "$DEVSTRAP_SSH_CONFIG/$NAME"
  _build_ssh_config
}

function uninstall_ssh_config() {
  local NAME=$1
  rm -f "$DEVSTRAP_SSH_CONFIG/$NAME"
  _build_ssh_config
}

function _build_ssh_config() {
  echo -n > $HOME/.ssh/config
  for file in $DEVSTRAP_SSH_CONFIG/*; do
    cat $file >> $HOME/.ssh/config
  done
}

function install_ssh_known_hosts() {
  local NAME=$1
  local CONFIG=$2
  mkdir -p "$DEVSTRAP_SSH_HOSTS"
  echo "$CONFIG" > "$DEVSTRAP_SSH_HOSTS/$NAME"
  _build_ssh_known_hosts
}

function uninstall_ssh_known_hosts() {
  local NAME=$1
  rm -f "$DEVSTRAP_SSH_HOSTS/$NAME"
  _build_ssh_known_hosts
}

function _build_ssh_known_hosts() {
  echo -n > $HOME/.ssh/known_hosts
  for file in $DEVSTRAP_SSH_HOSTS/*; do
    cat $file >> $HOME/.ssh/known_hosts
  done
}

function download() {
  local NAME=$1
  local URL=$2
  local FILE="/tmp/$NAME"
  curl -L -o $FILE $URL
  RET=$FILE
}
