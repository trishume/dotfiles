mkdir ~/.vim
if [ ! -e $HOME/.vim/bundle/vundle ]; then
echo "Installing Vundle"
    git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi