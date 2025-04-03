FROM kasmweb/desktop-deluxe:1.16.1-rolling-daily

# Add applications
USER root

RUN apt-get update && \
    apt-get install -y wget libasound2 libnspr4 libnss3 libxss1 libgtk-3-0

# Revert user back to default
USER kasm-user
