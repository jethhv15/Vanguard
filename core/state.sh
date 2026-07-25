#!/system/bin/sh
#
# Project Vanguard
# Module State
#

vg_state_get() {

    printf '%s\n' "$VG_CURRENT_MODULE_STATE"
}

vg_state_set() {

    state="$1"

    [ -n "$state" ] || return "$VG_ERR_INVALID"

    VG_CURRENT_MODULE_STATE="$state"

    return "$VG_SUCCESS"
}
