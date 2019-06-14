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
fi
  echo "BUILD_DIR is set to '$BUILD_DIR'"

# Get semantic version major number on package.json version
MAJOR_PACKAGE_VERSION="$(sed -nE 's/.*version.*"(([0-9]+)\.([0-9]+\.?)+)".*/\2/p' package.json)"

# Change into the website directory
cd $BUILD_DIR

# Get semantic version major number of the latest version of the docs
MAJOR_DOCS_VERSION="$(sed -nE '2 s/.*"(([0-9]+)\.([0-9]+\.?)+)".*/\2/p' versions.json)"

# Update the version of the docs if is necessary
if ! [ -z "$MAJOR_DOCS_VERSION" ] && [ $MAJOR_PACKAGE_VERSION == $MAJOR_DOCS_VERSION ]; then

  cd ..
  PACKAGE_VERSION="$(sed -nE 's/.*version.*"(([0-9]+)\.([0-9]+\.?)+)".*/\1/p' package.json)"
  cd $BUILD_DIR
  npm install && \
  npm run version $PACKAGE_VERSION
else
  echo "In case of a major release or first docs update; you need to do the version update manually"
  echo "Here you have more information about the manual versioning => https://github.com/clay/'$PROJECT_NAME'/tree/master/website#versioning-the-code"
fi
