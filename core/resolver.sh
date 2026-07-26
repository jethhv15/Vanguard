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

vg_resolver_contains() {

    target="$1"

    old_ifs="$IFS"
    IFS='
'

    for item in $VG_RESOLVE_ORDER
    do
        if [ "$item" = "$target" ]; then
            IFS="$old_ifs"
            return "$VG_SUCCESS"
        fi
    done

    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}

vg_dependency_resolve_internal() {

    vg_resolver_contains "$1"

    if [ "$?" -eq "$VG_SUCCESS" ]; then
        return "$VG_SUCCESS"
    fi

    deps="$(vg_registry_get_dependencies "$1")"

    if [ -n "$deps" ]; then

        old_ifs="$IFS"
        IFS=','

        for dep in $deps
        do
            [ -n "$dep" ] || continue

            vg_dependency_resolve_internal "$dep"
            rc=$?

            if [ "$rc" -ne "$VG_SUCCESS" ]; then
                IFS="$old_ifs"
                return "$rc"
            fi
        done

        IFS="$old_ifs"
    fi

    vg_resolver_contains "$1"

    if [ "$?" -ne "$VG_SUCCESS" ]; then

        if [ -z "$VG_RESOLVE_ORDER" ]; then
            VG_RESOLVE_ORDER="$1"
        else
            VG_RESOLVE_ORDER="${VG_RESOLVE_ORDER}
$1"
        fi

    fi

    return "$VG_SUCCESS"
}

vg_dependency_resolve() {

    root="$1"

    [ -n "$root" ] || return "$VG_ERR_INVALID"

    VG_RESOLVE_ORDER=""

    vg_dependency_resolve_internal "$root"

    return $?
}
