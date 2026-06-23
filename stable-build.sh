#!/bin/bash

# NOTE
# REPOS- set of repositories to be updated, typically in a multi-repo
# FORK_USER - username of github user, with a stable-build
# FORK_NAME - name we give to fork_user's remote repo
# ORG - username of organization
# ORIGIN - Username of new-person who forked the project.

REPOS=(
  "apis-common"
  "apis-main"
  "apis-web"
  "apis-emulator"
  "apis-bom"
  "apis-ccc"
  "apis-log"
  "apis-main_controller"
  "apis-service_center"
  "apis-tester"
)
FORK_USER="goyalpalak18"
FORK_NAME="goyal-fork"
BRANCH="build-successful-on-3.9.16"
ORIGIN="thechibuikem"
ORG="hyphae"

for REPO in "${REPOS[@]}"; do
  echo "=== Hyphae is Processing $REPO ==="

  if [ ! -d "$REPO" ]; then
    echo "=== Cloning $REPO ==="
    git clone "https://github.com/$ORIGIN/$REPO.git"
  fi

  if cd "$REPO" 2>/dev/null; then
    git restore .

    if ! git remote | grep -q "^$FORK_NAME$"; then
      git remote add $FORK_NAME "https://github.com/$FORK_USER/$REPO.git"
    fi

    git fetch $FORK_NAME "$BRANCH"
    git checkout -b stable-build "$FORK_NAME/$BRANCH"
    git push "https://github.com/$ORIGIN/$REPO.git" stable-build

    cd ..
    echo "=== Done: $REPO ==="

  else
    echo "--- Error: Could not enter directory $REPO ---"
  fi
done