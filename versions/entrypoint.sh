#!/bin/sh

set -e
set -u

# Make sure BUILD_DIR is set and default to website
if [ -z ${BUILD_DIR+x} ]; then
  echo "BUILD_DIR is not set, falling back to default"
  export BUILD_DIR="website"
fi
  echo "BUILD_DIR is set to '$BUILD_DIR'"

# Get the package.json version
PACKAGE_VERSION="$(grep \"version\" ./package.json | awk '{gsub(/[\",]/, ""); print $2}')"

# Change into the website directory
cd $BUILD_DIR;

# Get the latest version of the docs
DOCS_VERSION="$(cat versions.json | head -2 | tail -1 | awk '{gsub(/[",]/, ""); print $0}')"

# Update the version of the docs if is necessary
if ! [ "${DOCS_VERSION}" == "" ] && ! [ ${PACKAGE_VERSION} == ${DOCS_VERSION} ]; then
  npm install && \
  npm run version $PACKAGE_VERSION
else
  echo "No version update was performed"
fi
