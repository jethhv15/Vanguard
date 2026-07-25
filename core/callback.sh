#!/system/bin/sh
#
# Project Vanguard
# Callback Framework
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"

vg_invoke_callback() {

    callback="$1"

    [ -n "$callback" ] || return "$VG_ERR_INVALID"

    if ! command -V "$callback" 2>/dev/null | grep -q "^${callback} is a function"; then
        return "$VG_ERR_NOT_FOUND"
    fi

    "$callback"

    return $?
}
