FROM kasmweb/desktop-deluxe:1.16.1-rolling-daily

# Add applications
USER root

# Code from: https://github.com/linuxserver/docker-obsidian/tree/main
RUN \
    echo "**** add icon ****" && \
    curl -o \
      /kclient/public/icon.png \
      https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/obsidian-logo.png && \
    echo "**** install packages ****" && \
    apt-get update

RUN \
    DEBIAN_FRONTEND=noninteractive \
    echo "**** install obsidian ****" && \
    OBSIDIAN_VERSION=$(curl -sX GET "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"| awk '/tag_name/{print $4;exit}' FS='[""]'); \
    apt-get install -y --no-install-recommends \
      chromium \
      chromium-l10n \
      git \
      libgtk-3-bin \
      libatk1.0 \
      libatk-bridge2.0 \
      libnss3 \
      python3-xdg && \
    cd /tmp && \
    curl -o \
      /tmp/obsidian.app -L \
      "https://github.com/obsidianmd/obsidian-releases/releases/download/${OBSIDIAN_VERSION}/Obsidian-$(echo ${OBSIDIAN_VERSION} | sed 's/v//g').AppImage" && \
    chmod +x /tmp/obsidian.app && \
    ./obsidian.app --appimage-extract && \
    mv squashfs-root /opt/obsidian && \
    cp \
      /opt/obsidian/usr/share/icons/hicolor/512x512/apps/obsidian.png \
      /usr/share/icons/hicolor/512x512/apps/obsidian.png

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
