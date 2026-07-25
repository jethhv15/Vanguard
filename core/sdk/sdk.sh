#!/system/bin/sh
#
# Project Vanguard
# SDK Loader
#

#
# Resolve SDK Directory
#

if [ -z "${SDK_DIR:-}" ]; then
    SDK_DIR="$CORE_DIR/sdk"
fi

#
# Framework APIs
#

. "$SDK_DIR/framework.sh"

#
# Module APIs
#

. "$SDK_DIR/module.sh"

#
# SDK Services
#

. "$SDK_DIR/logger.sh"
. "$SDK_DIR/property.sh"
. "$SDK_DIR/filesystem.sh"
. "$SDK_DIR/hook.sh"
. "$SDK_DIR/state.sh"
