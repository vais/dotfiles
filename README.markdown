## Installation

### Unix
```
cd ~
git clone https://github.com/vais/dotfiles.git
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/vimfiles ~/.vim
```

### Windows
```
cd %HOMEPATH%
git clone https://github.com/vais/dotfiles.git
mklink .\_vimrc .\dotfiles\vimrc
mklink .\vimfiles .\dotfiles\vimfiles
```

### Then
```
cd dotfiles
git submodule update --init
```
