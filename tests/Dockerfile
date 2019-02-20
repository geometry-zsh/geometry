# docker build -t geometry-zsh-5.0.0 .
# docker run -rm -it geometry-zsh-5.0.0

FROM zshusers/zsh-5.0.0:latest

RUN \
  apt update && \
  DEBAIN_FRONTEND=noninteractive apt install -y curl locales

RUN adduser --shell /bin/zsh --gecos 'geometry' --disabled-password geometry
RUN locale-gen "en_US.UTF-8"

USER geometry
WORKDIR /home/geometry
ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color
ENV DEFUALT_USER=geometry

COPY ../ geometry
COPY zshrc .zshrc

USER root
RUN chown -R geometry:geometry geometry

USER geometry
