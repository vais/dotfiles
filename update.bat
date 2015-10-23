mklink "%HOMEPATH%\.gitconfig" "%HOMEPATH%\dotfiles\gitconfig"
mklink "%HOMEPATH%\.gitignore_global" "%HOMEPATH%\dotfiles\gitignore_global"

mklink "%HOMEPATH%\_vimrc" "%HOMEPATH%\dotfiles\vimrc"
mklink "%HOMEPATH%\vimfiles" "%HOMEPATH%\dotfiles\vimfiles"

pushd "%HOMEPATH%\dotfiles"
git pull
git submodule update --init
popd
