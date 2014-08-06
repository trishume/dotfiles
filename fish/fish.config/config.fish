# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
set -x DOTFILES $HOME/WorkBox/dotfiles
set -x PROJECTS $HOME/WorkBox/Dev
set -x FISH $HOME/.config/fish
set -x GOPATH $HOME/WorkBox/go
set -x EDITOR vim
#set -x SITE_DEPLOY_PATH ~/Box/Sites/thume
#set -x LEDGER_FILE ~/Box/Life/me.ldg
set PATH /usr/local/bin /usr/local/sbin $DOTFILES/bin $PATH /usr/local/opt/go/libexec/bin

set fish_custom $HOME/.config/fish/custom
set fish_theme thume

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

set fish_greeting ''

function fish_title
  echo (prompt_pwd)
end

alias git hub

function pd
  cd (pro search $argv)
end