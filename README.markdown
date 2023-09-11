## Install
```
cd ~
git clone https://github.com/vais/dotfiles.git
dotfiles/sync
```
## Sync
```
~/dotfiles/sync
```
## Vim Plugins
### Installing
```
cd ~/dotfiles
git submodule add PLUGIN_URL vimfiles/pack/plugins/start/PLUGIN_NAME
git commit -m "Install PLUGIN_NAME"
```
### Updating
```
~/dotfiles/update
```
### Removing
```
cd ~/dotfiles
git submodule deinit vimfiles/pack/plugins/start/PLUGIN_NAME
git rm vimfiles/pack/plugins/start/PLUGIN_NAME
rm -rf .git/modules/vimfiles/pack/plugins/start/PLUGIN_NAME
git commit -m "Remove PLUGIN_NAME"
```
