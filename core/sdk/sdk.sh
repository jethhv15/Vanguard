#!/system/bin/sh
#
# Project Vanguard
# SDK Loader
#

SDK_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

#
# Framework APIs
#

. "$SDK_DIR/framework.sh"

#
# Module APIs
#

. "$SDK_DIR/module.sh"

#
# Services
#
. "$SDK_DIR/module.sh"

if [ -f "$SDK_DIR/logger.sh" ]; then
    . "$SDK_DIR/logger.sh"
fi

if [ -f "$SDK_DIR/filesystem.sh" ]; then
    . "$SDK_DIR/filesystem.sh"
fi

if [ -f "$SDK_DIR/property.sh" ]; then
    . "$SDK_DIR/property.sh"
fi

if [ -f "$SDK_DIR/process.sh" ]; then
    . "$SDK_DIR/process.sh"
fi

if [ -f "$SDK_DIR/config.sh" ]; then
    . "$SDK_DIR/config.sh"
fi

if [ -f "$SDK_DIR/service.sh" ]; then
    . "$SDK_DIR/service.sh"
fi

if [ -f "$SDK_DIR/permission.sh" ]; then
    . "$SDK_DIR/permission.sh"
fi
