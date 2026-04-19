#: git-profile-personal — switch global git identity to personal account
git-profile-personal() {
  git config --global user.name "$GIT_PERSONAL_NAME"
  git config --global user.email "$GIT_PERSONAL_EMAIL"
  echo "Switched to personal git profile ($GIT_PERSONAL_NAME)"
}

#: git-profile-work — switch global git identity to work account
git-profile-work() {
  git config --global user.name "$GIT_WORK_NAME"
  git config --global user.email "$GIT_WORK_EMAIL"
  echo "Switched to work git profile ($GIT_WORK_NAME)"
}
