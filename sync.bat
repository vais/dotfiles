git -C "%HOMEPATH%\dotfiles" pull
git -C "%HOMEPATH%\dotfiles" submodule update --init --jobs 16

mklink "%HOMEPATH%\.gitconfig" "%HOMEPATH%\dotfiles\git\.gitconfig"
mklink "%HOMEPATH%\.gitignore_global" "%HOMEPATH%\dotfiles\git\.gitignore_global"

mklink "%HOMEPATH%\_vimrc" "%HOMEPATH%\dotfiles\vim\.vimrc"
mklink "%HOMEPATH%\_gvimrc" "%HOMEPATH%\dotfiles\vim\.gvimrc"
mklink "%HOMEPATH%\vimfiles" "%HOMEPATH%\dotfiles\vim\.vim"

mklink "%HOMEPATH%\.sql-formatter.json" "%HOMEPATH%\dotfiles\misc\.sql-formatter.json"
