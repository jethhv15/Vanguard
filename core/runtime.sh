#!/system/bin/sh
#
# Project Vanguard
# Runtime Context
#

#
# Load Dependencies
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/discovery.sh"
. "$CORE_DIR/validator.sh"

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

vg_runtime_mark_discovered() {

    VG_RUNTIME_DISCOVERED="true"

    return "$VG_SUCCESS"
}

vg_runtime_mark_validated() {

    VG_RUNTIME_VALIDATED="true"

    return "$VG_SUCCESS"
}

vg_runtime_reset() {

    VG_RUNTIME_INITIALIZED="false"
    VG_RUNTIME_DISCOVERED="false"
    VG_RUNTIME_VALIDATED="false"

    return "$VG_SUCCESS"
}

vg_runtime_is_initialized() {

    [ "$VG_RUNTIME_INITIALIZED" = "true" ]
}

vg_runtime_boot() {

    vg_runtime_reset

    vg_runtime_init || return $?

    vg_discover || return $?

    vg_runtime_mark_discovered

    if ! vg_validate_environment; then
        result=$?
        vg_runtime_reset
        return "$result"
    fi

    vg_runtime_mark_validated

    return "$VG_SUCCESS"
}
