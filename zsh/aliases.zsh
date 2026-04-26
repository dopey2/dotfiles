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