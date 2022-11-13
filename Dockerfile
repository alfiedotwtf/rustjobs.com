FROM debian:bullseye

ARG UID
ARG USER

# install minimal tools

RUN apt-get update

RUN apt-get install -y \
  curl \
  git \
  python3 \
  python3-pip \
  sudo \
  tmux

RUN pip3 install awscli

# fix locale for tmux

RUN apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# fix user

RUN useradd -m -u ${UID} -g sudo -s /bin/bash ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}
RUN echo 'PS1="DOCKER > \w \$ "' >> ~/.bashrc

# install Rust

RUN curl -LSso /tmp/rustup.sh https://sh.rustup.rs
RUN sh /tmp/rustup.sh -y
RUN echo "PATH=~/.cargo/bin:\$PATH" >> ~/.bashrc

RUN ~/.cargo/bin/rustup component add rust-analyzer rust-src
RUN ln -s `~/.cargo/bin/rustup which --toolchain stable rust-analyzer` ~/.cargo/bin/

RUN ~/.cargo/bin/cargo install sssg
EXPOSE 1337
