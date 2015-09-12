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

### Finally
```
cd dotfiles
git submodule update --init
```

## Adding plugins

### Installing
```
cd ~/dotfiles
git submodule add git://github.com/tpope/vim-repeat.git vimfiles/bundle/vim-repeat
git commit -m "Install Repeat.vim plugin"
```

### Updating
To update all installed plugins:
```
cd ~/dotfiles
git submodule foreach git pull origin master
git commit -m "Update plugins"
```
To update a single plugin:
```
cd ~/dotfiles/vimfiles/bundle/vim-repeat
git pull origin master
git commit -m "Update Repeat.vim plugin"
```

### Removing
```
cd ~/dotfiles
git submodule deinit vimfiles/bundle/vim-repeat
git rm vimfiles/bundle/vim-repeat
git commit -m "Remove Repeat.vim plugin"
```
