set -x DOTFILES $HOME/Box/Dev/Dotfiles
set -x PROJECTS $HOME/Box/Dev
set -x GOPATH $HOME/Box/Dev/Langs/go
set -x NODE_PATH /usr/local/lib/node
set -x EDITOR vim
set -x ALTERNATE_EDITOR vim
set -x SITE_DEPLOY_PATH $HOME/Box/Sites/thume
set -x LEDGER_FILE $HOME/Box/Life/me.ldg
if test $MACHINE = "TBook"
  set -x JAVA_HOME (/usr/libexec/java_home -v 1.8)
end

# PATH Setup

# Languages
if test $MACHINE = "TBox"
  set PATH /usr/local/bin $PATH # misc
else # Tbook
  # set PATH $PATH /Applications/Julia.app/Contents/Resources/julia/bin # Julia
  set PATH /Applications/Racket/bin $PATH # racket
  set PATH $HOME/Qt/5.3/clang_64/bin $PATH # Qt
  set PATH $HOME/Library/Haskell/bin $PATH # Haskell platform
  set PATH $GOPATH/bin $PATH /usr/local/opt/go/libexec/bin # go
  set PATH $HOME/.nimble/bin $PATH # Nim
  # set PATH /Applications/Emacs.app/Contents/MacOS/bin $PATH # emacs
  set PATH /usr/local/share/npm/bin $PATH # Node binaries
  set PATH /usr/local/opt/ruby/bin $PATH # Ruby executables
  set PATH /usr/local/bin /usr/local/sbin $PATH # homebrew
end

set PATH $HOME/bin $DOTFILES/bin $PATH # local bins
