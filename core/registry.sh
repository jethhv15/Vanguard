#!/system/bin/sh
#
# Project Vanguard
# Module Registry
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"

#
# Global Variables
#

VG_LOADED_MODULE_COUNT=0
VG_LOADED_MODULES=""

#
# Public Functions
#

vg_registry_reset() {

    VG_LOADED_MODULE_COUNT=0
    VG_LOADED_MODULES=""

    return "$VG_SUCCESS"
}

vg_registry_add() {

    module="$1"

    [ -n "$module" ] || return "$VG_ERR_INVALID"

    if [ -z "$VG_LOADED_MODULES" ]; then
        VG_LOADED_MODULES="$module"
    else
        VG_LOADED_MODULES="${VG_LOADED_MODULES}
$module"
    fi

    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))

    return "$VG_SUCCESS"
}
