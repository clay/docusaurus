#!/bin/sh

set -e
set -u

# Make sure PROJECT_NAME is set for the siteConfig.js file
if [ -z ${PROJECT_NAME+x} ]; then
  echo "PROJECT_NAME is not set, falling back to default"
  export PROJECT_NAME="site"
else
  echo "PROJECT_NAME is set to '$PROJECT_NAME'"
fi

# Make sure BUILD_DIR is set and default to website
if [ -z ${BUILD_DIR+x} ]; then
  echo "BUILD_DIR is not set, falling back to default"
  export BUILD_DIR="website"
else
  echo "BUILD_DIR is set to '$BUILD_DIR'"
fi

SSH_PATH="/root/.ssh"

mkdir "$SSH_PATH"
touch "$SSH_PATH/known_hosts"

echo "$DEPLOY_SSH_KEY" > "$SSH_PATH/id_rsa"

chmod 700 "$SSH_PATH"
chmod 600 "$SSH_PATH/known_hosts"
chmod 600 "$SSH_PATH/id_rsa"

eval $(ssh-agent)
ssh-add "$SSH_PATH/id_rsa"

ssh-keyscan -t rsa "github.com" >> "$SSH_PATH/known_hosts"
echo "StrictHostKeyChecking no" >> "$SSH_PATH/config"

# Change into the build directory
cd $BUILD_DIR;

git config --global user.name "$GITHUB_ACTOR" && \
git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com" && \
npm install && \
npm run build && \
npx gh-pages -d "build/$PROJECT_NAME" --repo "git@github.com:$GITHUB_REPOSITORY.git"
# We need for force an SSH connection to use the SSH key so
# we can specify the `--repo` flag to make sure `gh-pages`
# uses the SSH url https://github.com/tschaub/gh-pages/issues/160
