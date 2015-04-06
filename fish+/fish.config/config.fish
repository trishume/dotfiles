# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
set -x FISH $HOME/.config/fish

if test (hostname) = "Tbox3"
  set -x MACHINE TBox
else if test (hostname) = "WikiBox" -o (hostname) = "WikiBox2"
  set -x MACHINE WikiBox
else
  set -x MACHINE TBook
end

. $FISH/env.fish

set fish_custom $HOME/.config/fish/custom
set fish_theme thume

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler
if test $MACHINE = "TBook"
  set fish_plugins bundler localhost balias
else if test $MACHINE = "WikiBox"
  set fish_plugins bundler
else
  set fish_plugins bundler localhost percol gi rvm
end

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

set fish_greeting ''

function fish_title
  echo (prompt_pwd)
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

alias git hub
alias be "bundle exec"
alias tattach "tmux -2 attach-session -t tbox"
alias e "emacsclient -a vim -n -c"
alias scp-resume "rsync --partial -av --progress --rsh=ssh"

# if test $MACHINE = "TBook"
#   . $FISH/iterm.fish
# end
