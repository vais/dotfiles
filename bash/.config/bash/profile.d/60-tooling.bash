if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -r "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi
