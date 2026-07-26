#!/system/bin/sh
#
# Project Vanguard
# Module Startup Planner
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/resolver.sh"


VG_STARTUP_PLAN=""


vg_planner_reset() {

    VG_STARTUP_PLAN=""

    return "$VG_SUCCESS"
}



vg_planner_build() {

    module_id="$1"

    [ -n "$module_id" ] || return "$VG_ERR_INVALID"


    vg_dependency_resolve "$module_id"

    rc=$?

    [ "$rc" -eq "$VG_SUCCESS" ] || return "$rc"


    VG_STARTUP_PLAN="$VG_RESOLVE_ORDER"


    return "$VG_SUCCESS"
}
