# Automatically switch Node version based on nearest .nvmrc when changing dirs.
if command -v nvm >/dev/null 2>&1; then
  cdnvm() {
    command cd "$@" || return $?
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    if [[ ! $nvm_path = *[^[:space:]]* ]]; then
      default_version=$(nvm version default)
      if [[ $default_version == "N/A" ]]; then
        nvm alias default node
        default_version=$(nvm version default)
      fi

      if [[ $(nvm current) != "$default_version" ]]; then
        nvm use default
      fi
    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
      nvm_version=$(<"$nvm_path"/.nvmrc)
      locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')
      if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
        nvm install "$nvm_version"
      elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
        nvm use "$nvm_version"
      fi
    fi
  }

  alias cd='cdnvm'
  cdnvm "$PWD" || return
fi
