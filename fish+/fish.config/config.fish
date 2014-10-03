# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
set -x FISH $HOME/.config/fish

. $FISH/env.fish

set fish_custom $HOME/.config/fish/custom
set fish_theme thume

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler
set fish_plugins bundler localhost percol gi

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

alias git hub
alias be "bundle exec"
alias tattach "tmux -2 attach-session -t tbox"
