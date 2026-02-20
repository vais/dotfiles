# Shared Bash profile managed by GNU Stow from this repository.
# Machine-specific settings should go in ~/.bash_profile.local

if [ -d "$HOME/.config/bash/profile.d" ]; then
  for bash_profile_part in "$HOME/.config/bash/profile.d/"*.bash; do
    [ -r "$bash_profile_part" ] && . "$bash_profile_part"
  done
fi

if [ -r "$HOME/.bash_profile.local" ]; then
  . "$HOME/.bash_profile.local"
fi
