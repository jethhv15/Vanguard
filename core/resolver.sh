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


VG_RESOLVE_ORDER=""


vg_resolver_append() {

    append_id="$1"


    case "
$VG_RESOLVE_ORDER
" in
        *"
$append_id
"*)
            return "$VG_SUCCESS"
            ;;
    esac


    if [ -z "$VG_RESOLVE_ORDER" ]; then
        VG_RESOLVE_ORDER="$append_id"
    else
        VG_RESOLVE_ORDER="${VG_RESOLVE_ORDER}
$append_id"
    fi


    return "$VG_SUCCESS"
}



vg_resolver_walk() {

    walk_id="$1"


    walk_deps="$(vg_registry_get_dependencies "$walk_id")"


    if [ -n "$walk_deps" ]; then

        old_ifs="$IFS"
        IFS=','


        for dep_id in $walk_deps
        do
            [ -n "$dep_id" ] || continue

            vg_resolver_walk "$dep_id"

        done


        IFS="$old_ifs"

    fi


    vg_resolver_append "$1"

}



vg_dependency_resolve() {

    root_id="$1"


    [ -n "$root_id" ] || return "$VG_ERR_INVALID"


    VG_RESOLVE_ORDER=""


    vg_resolver_walk "$root_id"


    return "$VG_SUCCESS"
}
