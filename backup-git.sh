#!/bin/bash

set -e

export GIT_DIR="/var/git"
export GIT_WORK_TREE="$TARGET_FOLDER"

echo "$GIT_WORK_TREE"

if [ ! -d "$GIT_DIR" ]; then
    mkdir -p "$GIT_DIR"
    git init
    git config user.name "$GIT_NAME"
    git config user.email "$GIT_EMAIL"
    git remote add origin "$GIT_URL"

    mkdir -p "$GIT_DIR/info"
    echo '' > "$GIT_DIR/info/exclude"
    while IFS=';' read -ra IGNORE_PATTERNS; do
        for i in "${IGNORE_PATTERNS[@]}"; do
            echo "$i" >> "$GIT_DIR/info/exclude"
        done
    done <<< "$GIT_IGNORE"

    git fetch --all
    git symbolic-ref HEAD refs/remotes/origin/$GIT_BRANCH
    git reset
    git checkout -b $GIT_BRANCH
    git rm -r --cached . || true
fi

git add -A

git commit -m "$GIT_COMMIT_MESSAGE"
git push origin $GIT_BRANCH
