# Setup requirements in ~/.ssh/config
# GitHub authentication uses a symlink (~/.ssh/id_github) as the active key.
# Switching git profiles (git-profile-primary / git-profile-secondary) updates
# that symlink to point to the corresponding SSH key defined in secrets/tokens.zsh.
# This keeps this file static — only the symlink target changes, never this config.
#
# ~/.ssh/config:
# Host github.com
#   IdentityFile ~/.ssh/id_github
#   IdentitiesOnly yes
#   ServerAliveInterval 240


#: git-current — show the active git user name and email
git-current() {
  echo "$(git config --global user.name) <$(git config --global user.email)>"
}

#: git-profile-primary — switch to primary git profile
git-profile-primary() {
  # Global config used to sign commits
  git config --global user.name "$GIT_PRIMARY_NAME"
  git config --global user.email "$GIT_PRIMARY_EMAIL"
  # Symlink the primary SSH key to the default GitHub SSH key location
  # SSH key used for pushing authentication to remote repositories
  ln -sf $GIT_PRIMARY_SSH_KEY $HOME/.ssh/id_github
  echo "Switched to primary git profile ($GIT_PRIMARY_NAME)"
}

#: git-profile-secondary — switch to secondary git profile
git-profile-secondary() {
  # Global config used to sign commits
  git config --global user.name "$GIT_SECONDARY_NAME"
  git config --global user.email "$GIT_SECONDARY_EMAIL"
  # Symlink the secondary SSH key to the default GitHub SSH key location
  # SSH key used for pushing authentication to remote repositories
  ln -sf $GIT_SECONDARY_SSH_KEY $HOME/.ssh/id_github
  echo "Switched to secondary profile ($GIT_SECONDARY_NAME)"
}
