## Installing

### Unix
```
cd ~
git clone https://github.com/vais/dotfiles.git
dotfiles/update
```

### Windows
```
cd %HOMEPATH%
git clone https://github.com/vais/dotfiles.git
dotfiles\update
```

## Updating

### Unix
```
~/dotfiles/update
```

### Windows
```
%HOMEPATH%\dotfiles\update
```

## Vim Plugins
To install a new plugin:
```
cd ~/dotfiles
git submodule add git://github.com/tpope/vim-repeat.git vimfiles/bundle/vim-repeat
git commit -m "Install Repeat.vim plugin"
```
To update all installed plugins:
```
cd ~/dotfiles
git submodule foreach git pull origin master
git commit -am "Update all plugins"
```
To update a single plugin:
```
cd ~/dotfiles/vimfiles/bundle/vim-repeat
git pull origin master
git commit -am "Update Repeat.vim plugin"
```
To remove a plugin:
```
cd ~/dotfiles
git submodule deinit vimfiles/bundle/vim-repeat
git rm vimfiles/bundle/vim-repeat
git commit -m "Remove Repeat.vim plugin"
```
