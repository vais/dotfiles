# Ghostty shell integration for macOS Bash.
if [ -n "$GHOSTTY_RESOURCES_DIR" ] && [ -r "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash" ]; then
  . "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
fi
