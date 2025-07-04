git -C "%HOMEPATH%\dotfiles" pull
git -C "%HOMEPATH%\dotfiles" submodule update --init --jobs 16

mklink "%HOMEPATH%\.gitconfig" "%HOMEPATH%\dotfiles\gitconfig"
mklink "%HOMEPATH%\.gitignore_global" "%HOMEPATH%\dotfiles\gitignore_global"

mklink "%HOMEPATH%\_vimrc" "%HOMEPATH%\dotfiles\vimrc"
mklink "%HOMEPATH%\_gvimrc" "%HOMEPATH%\dotfiles\gvimrc"
mklink "%HOMEPATH%\vimfiles" "%HOMEPATH%\dotfiles\vimfiles"

mklink "%HOMEPATH%\.irbrc" "%HOMEPATH%\dotfiles\irbrc"

mklink "%HOMEPATH%\.ctags" "%HOMEPATH%\dotfiles\ctags"

mklink "%HOMEPATH%\.aider.conf.yml" "%HOMEPATH%\dotfiles\aider.conf.yml"

mklink "%HOMEPATH%\.sql-formatter.json" "%HOMEPATH%\dotfiles\sql-formatter.json"
