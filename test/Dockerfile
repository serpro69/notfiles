FROM ubuntu:jammy

ARG USERNAME=sergio
ARG DEBUG=false

RUN apt-get update && \
    apt-get -y install sudo && \
    groupadd -g 1000 $USERNAME &&  \
    useradd -u 1000 -g $USERNAME -G sudo -m -s /bin/bash $USERNAME && \
    echo "sergio:qwerty" | chpasswd && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Customized the sudoers file for passwordless access to the $USERNAME user!" && \
    echo "$USERNAME user:";  su - $USERNAME -c id

RUN apt-get update && apt-get -y install \
    curl \
    git \
    tmux \
    vim \
    zsh

WORKDIR /home/$USERNAME/dotfiles/

COPY . .

RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/dotfiles

RUN sudo chsh -s $(which zsh) $USERNAME

RUN if [ "$DEBUG" = "true" ]; then echo 'setopt SOURCE_TRACE' | sudo tee -a /etc/zsh/zshenv; fi

USER $USERNAME

RUN chmod +x ./init.zsh && ./init.zsh

CMD ["/usr/bin/zsh", "--login", "-i"]
