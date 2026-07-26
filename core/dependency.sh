#!/system/bin/sh
#
# Project Vanguard
# Dependency Resolver
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"


#
# Public API
#

vg_dependency_check() {

    module_id="$1"

    [ -n "$module_id" ] || return "$VG_ERR_INVALID"


    dependencies="$(vg_registry_get_dependencies "$module_id")"
    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then
        return "$rc"
    fi


    #
    # No dependency
    #

    [ -n "$dependencies" ] || return "$VG_SUCCESS"


    old_ifs="$IFS"
    IFS=','


    for dependency in $dependencies
    do

        [ -n "$dependency" ] || continue


        vg_registry_get_path "$dependency" >/dev/null 2>&1

        if [ "$?" -ne "$VG_SUCCESS" ]; then

            IFS="$old_ifs"

            return "$VG_ERR_DEPENDENCY"

        fi

    done


    IFS="$old_ifs"


    return "$VG_SUCCESS"
}
