#!/system/bin/sh
#
# Project Vanguard
# Module Loader
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/module_validator.sh"

#
# Public Functions
#

vg_load_module() {

    module_path="$1"

    [ -d "$module_path" ] || return "$VG_ERR_NOT_FOUND"

    manifest="$module_path/module.prop"

    vg_parse_manifest "$manifest" || return $?

    vg_validate_module || return $?

    entry="$module_path/$VG_MODULE_ENTRY"

    [ -f "$entry" ] || return "$VG_ERR_NOT_FOUND"
    [ -r "$entry" ] || return "$VG_ERR_INTERNAL"
    [ -s "$entry" ] || return "$VG_ERR_INVALID"

    . "$entry" || return "$VG_ERR_INTERNAL"

    command -v "vg_${VG_MODULE_ID}_init" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"

    command -v "vg_${VG_MODULE_ID}_start" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"

    command -v "vg_${VG_MODULE_ID}_stop" >/dev/null 2>&1 \
        || return "$VG_ERR_INVALID"

    return "$VG_SUCCESS"
}
