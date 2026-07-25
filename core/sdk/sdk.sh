#!/system/bin/sh
#
# Project Vanguard
# SDK Loader
#

SDK_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$SDK_DIR/framework.sh"
. "$SDK_DIR/module.sh"
