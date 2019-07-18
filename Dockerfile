FROM node:alpine

LABEL "com.github.actions.name"="Docusaurus actions"
LABEL "com.github.actions.description"="Handles all the documentation action."
LABEL "com.github.actions.icon"="book-open"
LABEL "com.github.actions.color"="blue-dark"

LABEL "repository"="https://github.com/clay/docusaurus-github-action"
LABEL "homepage"="https://github.com/clay/docusaurus-github-action"
LABEL "maintainer"="Jon Winton <@jonwinton>"


RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      git \
      openssl \
      openssh-client \
      autoconf \
      automake \
      bash \
      g++ \
      libc6-compat \
      libjpeg-turbo-dev \
      libpng-dev \
      make \
      nasm
      # We need these deps for git and docusaurus

ENV PATH="/usr/local/bin:${PATH}"

COPY bin /usr/local/bin/

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
