#!/system/bin/sh
#
# Project Vanguard
# Callback Framework
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

vg_invoke_callback() {

    callback="$1"

    [ -n "$callback" ] || return "$VG_ERR_INVALID"

    command -v "$callback" >/dev/null 2>&1 \
        || return "$VG_ERR_NOT_FOUND"

    "$callback"

    return $?
}
