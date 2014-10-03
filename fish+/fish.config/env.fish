set -x DOTFILES $HOME/Box/Dev/Dotfiles
set -x PROJECTS $HOME/Box/Dev
set -x GOPATH $HOME/Box/Dev/Langs/go
set -x NODE_PATH /usr/local/lib/node
set -x EDITOR vim
set -x SITE_DEPLOY_PATH ~/Box/Sites/thume
set -x LEDGER_FILE ~/Box/Life/me.ldg

# PATH Setup

# Languages
set PATH $PATH /Applications/Julia.app/Contents/Resources/julia/bin # Julia
set PATH /Applications/Racket6.1/bin $PATH # racket
set PATH $HOME/Qt/5.3/clang_64/bin $PATH # Qt
set PATH $HOME/Library/Haskell/bin $PATH # Haskell platform
set PATH $GOPATH/bin $DOTFILES/bin $PATH /usr/local/opt/go/libexec/bin # go
set PATH /usr/local/share/npm/bin $PATH # Node binaries
set PATH /usr/local/opt/ruby/bin $PATH # Ruby executables

set PATH /usr/local/bin /usr/local/sbin $PATH # homebrew
set PATH $HOME/bin $DOTFILES/bin $PATH # local bins
