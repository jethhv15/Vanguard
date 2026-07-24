#!/system/bin/sh
#
# Project Vanguard
# Runtime Context
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"

#
# Global Variables
#

VG_RUNTIME_INITIALIZED="false"
VG_RUNTIME_DISCOVERED="false"
VG_RUNTIME_VALIDATED="false"

#
# Public Functions
#

vg_runtime_init() {

    VG_RUNTIME_INITIALIZED="true"

    return "$VG_SUCCESS"
}

vg_runtime_is_initialized() {

    [ "$VG_RUNTIME_INITIALIZED" = "true" ]
}
