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
    vim \
    bash \
    ack \
    py-pip \
    diffutils \
    gnupg

COPY ./autoload/ /root/.vim/autoload/
COPY ./bundle/ /root/.vim/bundle/
COPY ./vimrc.d/ /root/.vim/vimrc.d/
COPY ./vimrc /root/.vim/
COPY ./Makefile /root/.vim/

RUN ln -sf /root/.vim/vimrc /root/.vimrc

# install fzf
RUN git clone --depth 1 --quiet https://github.com/junegunn/fzf.git /root/.vim/.fzf && /root/.vim/.fzf/install
RUN export FZF_DEFAULT_COMMAND="git ls-tree -r --name-only HEAD"
# finish install fzf

RUN pip install jedi
RUN pip install flake8

RUN cd /root/.vim && make




ENTRYPOINT ["vim"]
