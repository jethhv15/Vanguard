#!/system/bin/sh
#
# Project Vanguard
# SDK State API
#

vg_state_get() {

    printf '%s\n' "$VG_CURRENT_MODULE_STATE"
}

vg_state_set() {

    VG_CURRENT_MODULE_STATE="$1"

    return "$VG_SUCCESS"
}
