FROM alpine:latest

MAINTAINER SAbramov <pod2metra@gmail.com>

# Install dependencies
RUN apk add --no-cache \
    build-base \
    ctags \
    git \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    make \
    ncurses-dev \
    python \
    python-dev \
    ack \
    vim \
    bash

COPY ./autoload/ /root/.vim/autoload/
COPY ./bundle/ /root/.vim/bundle/
COPY ./vimrc.d/ /root/.vim/vimrc.d/
COPY ./vimrc /root/.vim/

RUN ln -sf /root/.vim/vimrc /root/.vimrc

RUN git clone --depth 1 --quiet https://github.com/junegunn/fzf.git /root/.vim/.fzf && /root/.vim/.fzf/install

ENTRYPOINT ["vim"]
