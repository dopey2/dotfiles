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

# requires fzf --> https://github.com/junegunn/fzf
#: gri - "git rebase -i" with fuzy finder for commit history.
alias gri='hash=$(git log --oneline | fzf | awk '{ print $1 }') && git rebase -i $hash'