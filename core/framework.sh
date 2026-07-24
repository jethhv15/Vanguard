#!/system/bin/sh
#
# Project Vanguard
# Framework Entry Point
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/logger.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/engine.sh"

#
# Public Functions
#

vg_framework_start() {

    vg_runtime_boot || return $?

    vg_engine_start || return $?

    return "$VG_SUCCESS"
}
