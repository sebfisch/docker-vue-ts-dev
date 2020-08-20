FROM node:alpine
CMD zsh --login

ARG HOME=/home/dev
ENV HOME=$HOME
ARG USER=dev
ENV USER=$USER
ARG UID=1000
ENV UID=$UID
ARG GROUP=dev
ENV GROUP=$GROUP
ARG GID=1000
ENV GID=$GID

ENV EDITOR=vim

RUN apk --no-cache add openssh git vim zsh curl && \
sed -i 's/bash$/zsh/g' /etc/passwd && \
addgroup --gid $GID $GROUP && \
adduser --disabled-password --gecos '' --uid $UID --ingroup $GROUP --shell /bin/zsh $USER
COPY --chown=$USER skel/* $HOME/

USER $USER

RUN yarn global add @vue/cli && \
vim +PlugInstall +qall && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
git clone https://github.com/reobin/typewritten.git $HOME/.oh-my-zsh/custom/themes/typewritten && \
ln -s $HOME/.oh-my-zsh/custom/themes/typewritten/typewritten.zsh-theme $HOME/.oh-my-zsh/custom/themes/typewritten.zsh-theme && \
sed -i -E 's/^(ZSH_THEME=).*$/\1"typewritten"/g' $HOME/.zshrc && \
sed -i -E 's/^(plugins=).*$/\1\(git vi-mode\)/g' $HOME/.zshrc

