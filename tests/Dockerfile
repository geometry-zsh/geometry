# You must build from the root repository directory, not the tests directory
# export VERSION=5.7.1
# docker build -t mnml:$VERSION -e VERSION=$VERSION -f tests/Dockerfile .
# docker run -e COLUMNS=$COLUMNS -e LINES=$LINES -e TERM=$TERM -it mnml:$VERSION zsh

ARG VERSION=latest

FROM zshusers/zsh:$VERSION

RUN \
  apt update && \
  DEBAIN_FRONTEND=noninteractive apt install -y git curl locales

RUN adduser --shell /bin/zsh --gecos 'mnml' --disabled-password mnml
RUN locale-gen "en_US.UTF-8"

USER mnml
WORKDIR /home/mnml
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV DEFAULT_USER=mnml

COPY . mnml
COPY tests/zshrc .zshrc

USER root
RUN chown -R mnml:mnml mnml

USER mnml
