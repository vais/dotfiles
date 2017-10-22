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
git submodule add PLUGIN_URL vimfiles/bundle/PLUGIN_NAME
git commit -m "Install PLUGIN_NAME"
```
To update all installed plugins:
```
cd ~/dotfiles
git submodule foreach git pull origin master
git commit -am "Update all plugins"
```
To update a single plugin:
```
cd ~/dotfiles/vimfiles/bundle/PLUGIN_NAME
git pull origin master
git commit -am "Update PLUGIN_NAME"
```
To remove a plugin:
```
cd ~/dotfiles
git submodule deinit vimfiles/bundle/PLUGIN_NAME
git rm vimfiles/bundle/PLUGIN_NAME
git commit -m "Remove PLUGIN_NAME"
rm -rf .git/modules/vimfiles/bundle/PLUGIN_NAME
```
