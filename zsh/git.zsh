#: git-current — show the active git user name and email
git-current() {
  echo "$(git config --global user.name) <$(git config --global user.email)>"
}

#: git-profile-primary — switch to primary git profile
git-profile-primary() {
  git config --global user.name "$GIT_PRIMARY_NAME"
  git config --global user.email "$GIT_PRIMARY_EMAIL"
  echo "Switched to primary git profile ($GIT_PRIMARY_NAME)"
}

#: git-profile-secondary — switch to secondary git profile
git-profile-secondary() {
  git config --global user.name "$GIT_SECONDARY_NAME"
  git config --global user.email "$GIT_SECONDARY_EMAIL"
  echo "Switched to secondary profile ($GIT_SECONDARY_NAME)"
}
