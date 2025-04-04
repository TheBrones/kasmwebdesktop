FROM kasmweb/desktop-deluxe:1.16.1-rolling-daily

# Add applications
USER root

# Code from: https://github.com/linuxserver/docker-obsidian/tree/main
RUN \
    echo "**** install packages ****" && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      chromium \
      chromium-l10n \
      git \
      libgtk-3-bin \
      libatk1.0 \
      libatk-bridge2.0 \
      libnss3 \
      python3-xdg

RUN \
    DEBIAN_FRONTEND=noninteractive \
    cd /tmp && \
    echo "**** install obsidian ****" && \
    OBSIDIAN_VERSION=$(curl -sX GET "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"| awk '/tag_name/{print $4;exit}' FS='[""]'); \
    curl -o \
      /tmp/obsidian.app -L \
      "https://github.com/obsidianmd/obsidian-releases/releases/download/${OBSIDIAN_VERSION}/Obsidian-$(echo ${OBSIDIAN_VERSION} | sed 's/v//g').AppImage" && \
    chmod +x /tmp/obsidian.app && \
    ./obsidian.app --appimage-extract && \
    mv squashfs-root /opt/obsidian

RUN \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
      /config/.cache \
      /config/.launchpadlib \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*

# Revert user back to default
USER kasm-user
