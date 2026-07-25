#!/system/bin/sh
#
# Project Vanguard
# SDK State API
#

vg_state_get() {

    printf '%s\n' "$VG_CURRENT_MODULE_STATE"
}

vg_state_set() {

    state="$1"

    [ -n "$state" ] || return "$VG_ERROR_INVALID_ARGUMENT"

    VG_CURRENT_MODULE_STATE="$state"

    return "$VG_SUCCESS"
}
