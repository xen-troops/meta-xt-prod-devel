
FROM ubuntu:16.04

ARG BUILDBOT
ARG PUB_KEY
ARG PRIV_KEY
ARG CONFIG
ARG BUILBOT_MAIL
ARG PROD
ARG MACHINE
ARG BRANCH

RUN apt-get update
# install the requiured prerequisites
RUN apt-get install gcc-5-aarch64-linux-gnu gcc-aarch64-linux-gnu -y
RUN apt-get remove gcc-5-multilib gcc-multilib
RUN apt-get install -y vim \
    cpio gawk wget diffstat texinfo chrpath socat libsdl1.2-dev \
    python-crypto repo checkpolicy python-git python-github \
    python-ctypeslib bzr pigz m4 lftp openjdk-8-jdk git-core \
    gnupg flex bison gperf build-essential zip curl zlib1g-dev \
    gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
    x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev \
    libxml2-utils xsltproc unzip python-clang-5.0 gcc-5 g++-5 bc \
    python-pip python3-pyelftools python3-pip python3-crypto \
    android-tools-fsutils libssl-dev \
    sudo policykit-1 locales && \
    dpkg-reconfigure locales  && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    pip install pycryptodome && \
    pip3 install pycryptodomex && \
    mkdir -p /mnt/work/build && \
    if [ "$BUILDBOT" != "root" ]; then \
    useradd -ms /bin/bash "$BUILDBOT" && \
    passwd -d $BUILDBOT && \
    usermod -aG sudo "$BUILDBOT" && \
    mkdir -p /home/"$BUILDBOT"/.ssh && \
    chown -R "$BUILDBOT" /home/"$BUILDBOT" ; \
    fi

RUN chown -R "$BUILDBOT" /mnt/work && \
    chown -R "$BUILDBOT" /usr/bin && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo && \
    echo "$BUILDBOT ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY "$PRIV_KEY" /root/.ssh/
COPY "$PUB_KEY" /root/.ssh/

USER "$BUILDBOT"

RUN curl https://storage.googleapis.com/git-repo-downloads/repo-1 > ~/repo && \
    chmod a+x ~/repo && \
    sudo cp ~/repo /usr/bin/ 

RUN echo "export LANG=en_US.UTF-8" >> ~/.profile && \
    git config --global user.email "$BUILBOT_MAIL" && \
    git config --global user.name "$BUILDBOT" && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan gitpct.epam.com >> ~/.ssh/known_hosts && \
    if [ "$HOME" != "/root" ]; then \
      sudo cp /root/.ssh/"$PRIV_KEY" ~/.ssh/ && \
      sudo cp /root/.ssh/"$PUB_KEY" ~/.ssh/ && \
      sudo chown -R "$BUILDBOT" ~/.ssh/"$PRIV_KEY" && \
      sudo chown -R "$BUILDBOT" ~/.ssh/"$PUB_KEY" ; \
    fi


RUN cd ~/ && git clone git@github.com:xen-troops/build-scripts.git && \
    cd ~/build-scripts && \
    python ./build_prod.py --build-type dailybuild --machine "$MACHINE" --product $PROD  --branch "$BRANCH" --with-local-conf --config ./$CONFIG && \
    echo "#!/bin/bash" >> ./continue_build.sh && \
    echo "python ./build_prod.py --build-type dailybuild --machine $MACHINE --product $PROD  --branch $BRANCH --with-local-conf --config ./$CONFIG --continue-build" >> ./continue_build.sh && \
    chmod +x ./continue_build.sh
    

USER root

