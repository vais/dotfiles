# Dotfiles

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

On macOS/Linux, `sync` also runs `stow --restow` for all packages.

On Windows, use `sync.bat` (no GNU Stow).

## Plugin Management

### Vim

#### Installing

```
cd ~/dotfiles
git submodule add PLUGIN_URL vim/.vim/pack/plugins/start/PLUGIN_NAME
git commit -m "Install PLUGIN_NAME"
```

#### Updating

```
~/dotfiles/update/vim
```

#### Removing

```
cd ~/dotfiles
git submodule deinit vim/.vim/pack/plugins/start/PLUGIN_NAME
git rm vim/.vim/pack/plugins/start/PLUGIN_NAME
rm -rf .git/modules/vim/.vim/pack/plugins/start/PLUGIN_NAME
git commit -m "Remove PLUGIN_NAME"
```

### Neovim

#### Installing

```
cd ~/dotfiles
git submodule add PLUGIN_URL nvim/.config/nvim/pack/plugins/start/PLUGIN_NAME
git commit -m "Install PLUGIN_NAME"
```

#### Updating

```
~/dotfiles/update/nvim
```

#### Removing

```
cd ~/dotfiles
git submodule deinit nvim/.config/nvim/pack/plugins/start/PLUGIN_NAME
git rm nvim/.config/nvim/pack/plugins/start/PLUGIN_NAME
rm -rf .git/modules/nvim/.config/nvim/pack/plugins/start/PLUGIN_NAME
git commit -m "Remove PLUGIN_NAME"
```
