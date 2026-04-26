#: wezterm — launch WezTerm (flatpak)
alias wezterm='flatpak run org.wezfurlong.wezterm'

#: c - clear
alias c='clear'

# requires eza --> https://github.com/ogham/exa#installation
#: ll - like ls -l
#: la - like ls -la
alias ll='eza -ll'
alias la='eza -la'


#: resource - reload the zsrch
alias resource='source ~/.zshrc && echo "zshrc reloaded !"'


## git aliases

#: glog - git log visualisation
alias glog='git log --oneline --graph --decorate --all'

#: gundo - git reset --soft HEAD~1
alias gundo='git reset --soft HEAD~1'

#: gpush - git push -u origin currentBranchName
alias gpush='git push --set-upstream origin $(git branch --show-current)'

#: gap - git add -p
alias gap='git add -p'

# requires fzf --> https://github.com/junegunn/fzf
#: gri - "git rebase -i" with fuzy finder for commit history.
gri() {
  local hash=$(git log --oneline | fzf | awk '{ print $1 }')
  [[ -n $hash ]] && git rebase -i $hash
}
