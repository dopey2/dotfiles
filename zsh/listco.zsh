#: listco — list all custom commands with descriptions
listco() {
  grep -rh "^#:" "$DOTFILES/zsh/"*.zsh | sed 's/^#: //'
}
