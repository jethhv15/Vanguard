#!/system/bin/sh
#
# Project Vanguard
# Module Validator
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"

#
# Public Functions
#

vg_validate_module() {

    [ -n "$VG_MODULE_ID" ] || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_NAME" ] || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_VERSION" ] || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_VERSION_CODE" ] || return "$VG_ERR_INVALID"

    case "$VG_MODULE_VERSION_CODE" in
        *[!0-9]*)
            return "$VG_ERR_INVALID"
            ;;
    esac

    [ -n "$VG_MODULE_AUTHOR" ] || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_API" ] || return "$VG_ERR_INVALID"

    [ -n "$VG_MODULE_ENTRY" ] || return "$VG_ERR_INVALID"

    return "$VG_SUCCESS"
}
