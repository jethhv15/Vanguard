#!/system/bin/sh
#
# Project Vanguard
# Module Registry
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"

VG_LOADED_MODULE_COUNT=0
VG_LOADED_MODULES=""

vg_registry_reset() {

    VG_LOADED_MODULE_COUNT=0
    VG_LOADED_MODULES=""

    return "$VG_SUCCESS"
}

vg_registry_add() {

    module_id="$1"
    module_path="$2"

    [ -n "$module_id" ] || return "$VG_ERR_INVALID"
    [ -n "$module_path" ] || return "$VG_ERR_INVALID"

    if [ -z "$VG_LOADED_MODULES" ]; then
        VG_LOADED_MODULES="${module_id}|${module_path}"
    else
        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${module_id}|${module_path}"
    fi

    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))

    return "$VG_SUCCESS"
}
