#!/system/bin/sh
#
# Project Vanguard
# Callback Framework
#

vg_invoke_callback() {

    callback="$1"

    [ -n "$callback" ] || return "$VG_ERROR_INVALID_ARGUMENT"

    command -v "$callback" >/dev/null 2>&1 || \
        return "$VG_ERROR_NOT_FOUND"

    "$callback"

    return $?
}
