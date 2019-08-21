# You must build from the root repository directory, not the tests directory
#    export VERSION=5.7.1
#    docker build -t geometry-zsh:$VERSION --build-arg=VERSION=$VERSION -f tests/Dockerfile .
#    docker run -e COLUMNS=$COLUMNS -e LINES=$LINES -e TERM=$TERM -it geometry-zsh:$VERSION zsh

ARG VERSION=latest

FROM zshusers/zsh:$VERSION

RUN \
  apt update && \
  DEBAIN_FRONTEND=noninteractive apt install -y git curl locales

RUN adduser --shell /bin/zsh --gecos geometry --disabled-password geometry
RUN locale-gen en_US.UTF-8

USER geometry
WORKDIR /home/geometry
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV DEFAULT_USER=geometry

COPY . geometry
COPY tests/zshrc .zshrc

USER root
RUN chown -R geometry:geometry geometry

USER geometry
