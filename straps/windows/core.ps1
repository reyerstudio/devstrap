#requires -v 3

# Remote install
# $ iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/reyerstudio/devstrap/master/straps/windows/core.ps1')
$erroractionpreference = 'stop' # quit if anything goes wrong

# Get core functions
$scoop_core_url = 'https://raw.githubusercontent.com/lukesampson/scoop/master/lib/core.ps1'

# Installing core environment
echo 'Installing core environment...'
iex (new-object net.webclient).downloadstring($scoop_core_url)

# Installing or updating scoop
if (-Not (installed 'scoop')) {
  echo "Installing scoop..."
  iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
} else {
  scoop update
}

# Define some helpers
$dir = resolve-path (appdir 'scoop')
. "$dir\current\lib\buckets.ps1"

function install_or_update($app) {
  if (installed $app) {
    scoop update $app -q
  } else {
    scoop install $app
  }
}

function add_bucket($name,$repos) {
  $dir = bucketdir $name
  if (-Not (test-path $dir)) {
    scoop bucket add $name $repos
  }
}

# Adding buckets
# git is required for bucket addition
install_or_update git
add_bucket extras https://github.com/lukesampson/scoop-extras.git
add_bucket devstrap https://github.com/reyerstudio/devstrap.git

# Installing core utils and tools
$packages = "7zip coreutils curl diffutils findutils gawk git grep gzip jq less make mercurial netcat openssh openssl patch rsync sed shasum sudo tar time touch vim wget which"
foreach($package in $packages.split(" ")) {
  install_or_update $package
}

# Installation Rapid Administration tool
install_or_update ra

# Don't continue to install
success "Close this console and launch another one for further strapping"