export BASH_SILENCE_DEPRECATION_WARNING=1

if [[ $- == *i* ]]; then
  bind "set completion-ignore-case on"
  bind "set show-all-if-ambiguous on"
fi
