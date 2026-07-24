#!/system/bin/sh
#
# Project Vanguard
# Engine
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/scanner.sh"

#
# Public Functions
#

vg_engine_start() {

    vg_runtime_is_initialized || return "$VG_ERR_INTERNAL"

    #
    # Scan available modules
    #

    vg_scan_modules >/dev/null || return $?

    #
    # Module pipeline
    #
    # Parser
    # Module Validator
    # Loader
    # Lifecycle
    #

    return "$VG_SUCCESS"
}
