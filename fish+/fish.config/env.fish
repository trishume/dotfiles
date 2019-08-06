if test $THIS_MACHINE = "Vagrant"
  set -x DOTFILES $HOME/dotfiles
else
  set -x DOTFILES $HOME/Box/Dev/Dotfiles
end
set -x PROJECTS $HOME/Box/Dev
set -x GOPATH $HOME/Box/Dev/Langs/go
set -x NODE_PATH /usr/local/lib/node:/usr/local/lib/node_modules
set -x EDITOR vim
set -x ALTERNATE_EDITOR vim
set -x SITE_DEPLOY_PATH $HOME/Box/Sites/thume
set -x LEDGER_FILE $HOME/Box/Life/me.ldg
set -x PRY
set -x DISABLE_SPRING

# Random programs
if test $THIS_MACHINE = "TBook"
  set -x JAVA_HOME (/usr/libexec/java_home -v 1.8)
end

# if which keychain > /dev/null
#   set -gx HOSTNAME (hostname)
#   if status --is-interactive;
#     keychain --nogui ~/.ssh/id_rsa
#     [ -e $HOME/.keychain/$HOSTNAME-fish ]; and . $HOME/.keychain/$HOSTNAME-fish
#   end
# end

# PATH Setup

# Languages
if test $THIS_MACHINE = "TBox"
  set PATH /usr/local/bin $PATH # misc
  set PATH $HOME/bin/nim/bin $PATH # Nim
else if test $THIS_MACHINE = "WikiBox"
  set PATH $HOME/bin/nim/bin $PATH # Nim
else if test $THIS_MACHINE = "Vagrant"
  set PATH /home/vagrant/.gem/ruby/2.1.6/bin /usr/lib/shopify-ruby/2.1.6-shopify1/lib/ruby/gems/2.1.0/bin /usr/lib/shopify-ruby/2.1.6-shopify1/bin $PATH
  set PATH /usr/local/heroku/bin $PATH /home/vagrant/src/go/bin
else if test $THIS_MACHINE = "TBook" # Tbook
  # set PATH $PATH /Applications/Julia.app/Contents/Resources/julia/bin # Julia
  # set PATH $PATH $HOME/Box/Dev/Projects/gutenberg/target/release
  set PATH $PATH /Applications/JuliaPro-0.6.0.1.app/Contents/Resources/julia/Contents/Resources/julia/bin
  set PATH "/Applications/Sublime Text.app/Contents/SharedSupport/bin" $PATH
  set PATH /Applications/Racket/bin $PATH # racket
  # set PATH $HOME/Qt/5.3/clang_64/bin $PATH # Qt
  set PATH $HOME/Library/Haskell/bin $PATH # Haskell platform
  set PATH $HOME/.local/bin $PATH # Haskell Stack
  set PATH $GOPATH/bin $PATH /usr/local/opt/go/libexec/bin # go
  # set PATH $HOME/bin/nim/bin $HOME/.nimble/bin $PATH # Nim
  # set PATH $HOME/bin/depot_tools $PATH # Chrome Depot Tools
  # set PATH /Applications/Emacs.app/Contents/MacOS/bin $PATH # emacs
  set PATH /usr/local/share/npm/bin $PATH # Node binaries
  set PATH /Users/tristan/.cargo/bin $PATH # Rust binaries
  set -x RUST_SRC_PATH /Users/tristan/Documents/rustc-1.6.0/src
  set PATH /usr/local/opt/ruby/bin $PATH # Ruby executables
  set PATH /usr/local/bin /usr/local/sbin $PATH # homebrew
  set PATH /Users/tristan/Library/Python/2.7/bin $PATH # voltron Python
  set PATH /Users/tristan/misc/apitrace/build $PATH # apitrace
  set PATH /Users/tristan/bin/google-cloud-sdk/bin $PATH # Google Cloud
  set PATH /Users/tristan/bin/zig $PATH # Zig
  set PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $PATH # VSCode
  set PATH "/Applications/Sublime Merge.app/Contents/SharedSupport/bin" $PATH # Sublime Merge
  set PYTHONPATH /usr/local/lib/python2.7/site-packages $PYTHONPATH

  # set -x QTDIR64 $HOME/Qt/5.5/clang_64
  set -x QT_DIR $HOME/Qt5.8.0/


  # OCaml OPAM
  # . /Users/tristan/.opam/opam-init/variables.fish > /dev/null 2> /dev/null or true
  set PATH "/Users/tristan/.opam/system/bin" $PATH
  set -x OCAML_TOPLEVEL_PATH "/Users/tristan/.opam/system/lib/toplevel"
  set MANPATH "$MANPATH" "/Users/tristan/.opam/system/man"
  set -x OPAMUTF8MSGS "1"
  set -x CAML_LD_LIBRARY_PATH "/Users/tristan/.opam/system/lib/stublibs:/usr/local/lib/ocaml/stublibs"

  set -x RUST_SRC_PATH /Users/tristan/Documents/rustc-1.8.0/src

  # Nix
  # set -xg NIX_LINK "$HOME/.nix-profile"
  # set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
  # set -xg  NIX_PATH $NIX_PATH "nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs"
  # set -xg SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
  set -x NIX_REMOTE daemon
  set -x NIX_USER_PROFILE_DIR "/nix/var/nix/profiles/per-user/$USER"
  set -x NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"
  set -x NIX_SSL_CERT_FILE "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
  set -x NIX_PATH "/nix/var/nix/profiles/per-user/root/channels"
  set PATH "/nix/var/nix/profiles/default/bin" $PATH
end

set PATH $HOME/bin $DOTFILES/bin $PATH # local bins
