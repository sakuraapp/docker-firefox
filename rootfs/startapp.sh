#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

#export HOME=/config
#mkdir -p /config/profile
firefox --version
exec /usr/bin/firefox_wrapper --setDefaultBrowser
