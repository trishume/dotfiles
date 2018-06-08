# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
set -x FISH $HOME/.config/fish

if test (hostname) = "Tbox3"
  set -x THIS_MACHINE TBox
else if test (hostname) = "WikiBox" -o (hostname) = "WikiBox2"
  set -x THIS_MACHINE WikiBox
else if test (hostname) = "vagrant.myshopify.io"
  set -x THIS_MACHINE Vagrant
else if test (hostname) = "Tristans-MacBook-Pro.local"
  set -x THIS_MACHINE WorkBook
else
  set -x THIS_MACHINE TBook
end

. $FISH/env.fish

set fish_custom $HOME/.config/fish/custom
set fish_theme thume

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler
if test $THIS_MACHINE = "TBook"
  set fish_plugins localhost balias
else if test $THIS_MACHINE = "WikiBox"
  set fish_plugins
else
  set fish_plugins localhost percol gi rvm
end

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

set fish_greeting ''

function fish_title
  echo (basename $PWD)
end

function fish_user_key_bindings
  bind \cr percol_select_history
end

function pd
  cd (pro search $argv)
end

function r --description 'Cd the current ranger tab'
  curl -X POST --data $PWD http://localhost:5964/cd
end

function ranger_shell_tab --on-variable PWD --description 'Update the ranger tab'
  curl -X POST --data $PWD --connect-timeout 0.05 http://localhost:5964/cdtab-s 2> /dev/null
end

function ensimeServer
  /Users/tristan/Library/Application\ Support/Sublime\ Text\ 3/Packages/Ensime/serverStart.sh .ensime
end

alias git hub
alias be "bundle exec"
alias tattach "tmux -2 attach-session -t tbox"
alias e "emacsclient -a vim -n -c"
alias scp-resume "rsync --partial -av --progress --rsh=ssh"

if test $THIS_MACHINE = "TBook"
  . $FISH/iterm.fish
end
