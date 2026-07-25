#!/system/bin/sh
#
# Project Vanguard
# Engine
#

CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/scanner.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/lifecycle.sh"
. "$CORE_DIR/hooks.sh"
. "$CORE_DIR/service.sh"
. "$CORE_DIR/event.sh"

vg_engine_start() {

    vg_runtime_is_initialized || return "$VG_ERR_INTERNAL"

    vg_registry_reset || return $?

    vg_scan_modules || return $?

    OLD_IFS=$IFS
    IFS='
'

    for module in $VG_SCANNED_MODULES
    do
        vg_load_module "$module" || {
            IFS=$OLD_IFS
            return $?
        }

        manifest="$module/module.prop"

        vg_parse_manifest "$manifest" || {
            IFS=$OLD_IFS
            return $?
        }

        vg_registry_add "$VG_MODULE_ID" "$module" || {
            IFS=$OLD_IFS
            return $?
        }
    done

    IFS=$OLD_IFS

    vg_lifecycle_init || return $?

    vg_lifecycle_start || return $?

    return "$VG_SUCCESS"
}
