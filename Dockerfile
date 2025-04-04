FROM kasmweb/desktop-deluxe:1.16.1-rolling-daily
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install apt applications
RUN \
    echo "**** install packages ****" && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      git \
      bmon \
      ncdu \
      htop \
      btop \
      filezilla \
      libgtk-3-bin \
      libatk1.0 \
      libatk-bridge2.0 \
      libnss3 \
      python3-xdg

# Install Obsidian 
# Code from: https://github.com/linuxserver/docker-obsidian/tree/main
RUN \
    DEBIAN_FRONTEND=noninteractive \
    cd /tmp && \
    OBSIDIAN_VERSION=$(curl -sX GET "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"| awk '/tag_name/{print $4;exit}' FS='[""]'); \
    curl -o \
      /tmp/obsidian.deb -L \
      "https://github.com/obsidianmd/obsidian-releases/releases/download/${OBSIDIAN_VERSION}/obsidian_$(echo ${OBSIDIAN_VERSION} | sed 's/v//g')_amd64.deb" && \
    apt install /tmp/obsidian.deb

# Install Bitwarden
RUN \
    DEBIAN_FRONTEND=noninteractive \
    cd /tmp && \
    curl -o \
      /tmp/bitwarden.deb -L \
      "https://bitwarden.com/download/?app=desktop&platform=linux&variant=deb" && \
    apt install /tmp/obsidian.deb

RUN \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
      /config/.cache \
      /config/.launchpadlib \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000