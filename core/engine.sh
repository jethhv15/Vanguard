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
. "$CORE_DIR/registry.sh"

vg_engine_start() {

    vg_runtime_is_initialized || return "$VG_ERR_INTERNAL"

    vg_registry_reset || return $?

    vg_scan_modules | while IFS= read -r module
    do
        vg_load_module "$module" || return $?
    done

    return "$VG_SUCCESS"
}
