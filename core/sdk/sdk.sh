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
# SDK Services
#

. "$SDK_DIR/logger.sh"
. "$SDK_DIR/property.sh"
. "$SDK_DIR/filesystem.sh"
. "$SDK_DIR/hook.sh"
