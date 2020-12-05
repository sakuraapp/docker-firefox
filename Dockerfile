#
# firefox Dockerfile
#
# https://github.com/jlesage/docker-firefox
#

# Build the membarrier check tool.
FROM alpine:3.12
WORKDIR /tmp
COPY helpers/* /usr/local/bin/
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check
RUN mv /tmp/membarrier_check /usr/bin/


# Base setup
# Install packages.
RUN \
    apk add \
        # X virtual framebuffer display server
        xvfb \
        xdpyinfo \
        # Openbox window manager
        openbox \
        xsetroot \
        ffmpeg \
        xdotool \
        ttf-dejavu

ENV DISPLAY=:0 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=720

RUN apk add firefox

# Add files.
COPY rootfs/ /

# Adjust the openbox config.
RUN \
    # Maximize only the main window.
    sed-patch 's/<application type="normal">/<application type="normal" title="Mozilla Firefox">/' \
        /etc/xdg/openbox/rc.xml && \
    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="Mozilla Firefox">/a \    <layer>below</layer>' \
        /etc/xdg/openbox/rc.xml

# Set environment variables.
ENV APP_NAME="Firefox"

# Metadata.
LABEL \
      org.label-schema.name="firefox" \
      org.label-schema.description="Docker container for Firefox" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-firefox" \
      org.label-schema.schema-version="1.0"

COPY init.sh /

ENTRYPOINT [ "/init.sh" ]