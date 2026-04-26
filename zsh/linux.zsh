#: open — open files/URLs with default app
alias open='xdg-open'

#: copy — copy to clipboard: `copy something` or `echo something | copy`
copy() {
  if [[ $# -gt 0 ]]; then
    echo -n "$*" | xclip -selection clipboard
  else
    xclip -selection clipboard
  fi
}
