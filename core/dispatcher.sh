#!/system/bin/sh
#
# Project Vanguard
# Module Dispatcher
#

#
# Load Dependencies
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/context.sh"

#
# Public API
#

vg_dispatch_module() {

    module_path="$1"
    action="$2"

    [ -n "$module_path" ] || return "$VG_ERR_INVALID"
    [ -n "$action" ] || return "$VG_ERR_INVALID"

    manifest="$module_path/module.prop"

    vg_parse_manifest "$manifest" || return $?

    vg_context_set "$module_path" || return $?

    callback="vg_${VG_MODULE_ID}_${action}"

    command -v "$callback" >/dev/null 2>&1 || {
        vg_context_clear
        return "$VG_ERR_INVALID"
    }

    "$callback"

    result=$?

    vg_context_clear

    return "$result"
}
