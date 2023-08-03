## Install

### Unix
```
cd ~
git clone https://github.com/vais/dotfiles.git
dotfiles/sync
```

### Windows
```
cd %HOMEPATH%
git clone https://github.com/vais/dotfiles.git
dotfiles\sync
```

## Sync

### Unix
```
~/dotfiles/sync
```

### Windows
```
%HOMEPATH%\dotfiles\sync.bat
```

## Vim Plugins
To install a new plugin:
```
cd ~/dotfiles
git submodule add PLUGIN_URL vimfiles/pack/plugins/start/PLUGIN_NAME
git commit -m "Install PLUGIN_NAME"
```
To update all installed plugins:
```
cd ~/dotfiles
git submodule update --remote --jobs 16
git commit -am "Update all plugins"
```
To update a single plugin:
```
cd ~/dotfiles
git submodule update --remote PLUGIN_NAME
git commit -am "Update PLUGIN_NAME"
```
To remove a plugin:
```
cd ~/dotfiles
git submodule deinit vimfiles/pack/plugins/start/PLUGIN_NAME
git rm vimfiles/pack/plugins/start/PLUGIN_NAME
rm -rf .git/modules/vimfiles/pack/plugins/start/PLUGIN_NAME
git commit -m "Remove PLUGIN_NAME"
```
