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


#
# Internal helper
#

vg_planner_contains() {

    target="$1"

    old_ifs="$IFS"
    IFS='
'

    for item in $VG_STARTUP_PLAN
    do
        [ "$item" = "$target" ] && {
            IFS="$old_ifs"
            return "$VG_SUCCESS"
        }
    done

    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



vg_planner_append() {

    module_id="$1"

    vg_planner_contains "$module_id"

    [ "$?" -eq "$VG_SUCCESS" ] && return "$VG_SUCCESS"


    if [ -z "$VG_STARTUP_PLAN" ]; then
        VG_STARTUP_PLAN="$module_id"
    else
        VG_STARTUP_PLAN="${VG_STARTUP_PLAN}
${module_id}"
    fi


    return "$VG_SUCCESS"
}



#
# Public API
#

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


    old_ifs="$IFS"
    IFS='
'


    for resolved in $VG_RESOLVE_ORDER
    do
        vg_planner_append "$resolved"
    done


    IFS="$old_ifs"


    return "$VG_SUCCESS"
}



vg_planner_build_all() {

    vg_planner_reset


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_LOADED_MODULES
    do

        module_id="${entry%%|*}"

        [ -n "$module_id" ] || continue


        vg_planner_build "$module_id"

        rc=$?

        if [ "$rc" -ne "$VG_SUCCESS" ]; then
            IFS="$old_ifs"
            return "$rc"
        fi

    done


    IFS="$old_ifs"


    return "$VG_SUCCESS"
}
