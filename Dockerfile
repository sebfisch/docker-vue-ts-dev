FROM node:alpine
CMD tmux new -s dev

ARG USER=me
ENV USER=$USER
ARG HOME=/home/$USER
ENV HOME=$HOME
ARG UID=501
ENV UID=$UID
ARG GROUP=$USER
ENV GROUP=$GROUP
ARG GID=501
ENV GID=$GID

ENV EDITOR=vim

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories && \
apk --no-cache add openssh tzdata git vim tmux bash zsh curl fzf ripgrep perl && \
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin && \
sed -i 's/bash$/zsh/g' /etc/passwd && \
addgroup --gid $GID $GROUP && \
adduser --disabled-password --gecos '' --uid $UID --ingroup $GROUP --shell /bin/zsh $USER
COPY --chown=$USER skel/* $HOME/

USER $USER

RUN yarn global add @vue/cli && \
vim +PlugInstall +qall && \
sed -i 's/delek/monokai_pro/g' $HOME/.vimrc && \
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm && \
$HOME/.tmux/plugins/tpm/bin/install_plugins
