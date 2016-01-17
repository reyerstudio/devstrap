# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias r="cd ~/${DEVSTRAP_NAME:-devstrap}"
alias rc="cd ~/${DEVSTRAP_NAME:-devstrap}/contrib"
alias rr="cd ~/${DEVSTRAP_NAME:-devstrap}/repos"
alias rw="cd ~/${DEVSTRAP_NAME:-devstrap}/workspace"

# Always enable colored `grep` output
alias grep='grep --color=auto'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias ll="ls -laF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# Lock the screen (when going Away From Keyboard)
if [ "$OSNAME" == "Darwin" ]; then
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend";
elif [ "$OSNAME" == "Linux" ]; then
  alias afk="gnome-screensaver-command --lock";
fi

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# External IP address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com";

if [ "$OSNAME" == "Darwin" ]; then
  # OS X has no `md5sum`, so use `md5` as a fallback
  command -v md5sum > /dev/null || alias md5sum="md5";

  # OS X has no `sha1sum`, so use `shasum` as a fallback
  command -v sha1sum > /dev/null || alias sha1sum="shasum";

  # OS X has no `sha256sum`, so use `shasum` as a fallback
  command -v sha256sum > /dev/null || alias sha256sum="shasum -a 256";

  # Hide/show all desktop icons (useful when presenting)
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder";

  # Disable Spotlight
  alias spotoff="sudo mdutil -a -i off";
  # Enable Spotlight
  alias spoton="sudo mdutil -a -i on";
fi