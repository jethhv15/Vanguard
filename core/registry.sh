#!/system/bin/sh
#
# Project Vanguard
# Registry
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


VG_LOADED_MODULES=""
VG_LOADED_MODULE_COUNT=0


vg_registry_reset() {

    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0

    return "$VG_SUCCESS"
}



vg_registry_add() {

    vg_registry_add_id="$1"
    vg_registry_add_path="$2"
    vg_registry_add_deps="$3"


    [ -n "$vg_registry_add_id" ] || return "$VG_ERR_INVALID"
    [ -n "$vg_registry_add_path" ] || return "$VG_ERR_INVALID"


    if vg_registry_get_path "$vg_registry_add_id" >/dev/null 2>&1; then
        return "$VG_ERR_GENERAL"
    fi


    vg_registry_add_entry="${vg_registry_add_id}|${vg_registry_add_path}|${vg_registry_add_deps}"


    if [ -z "$VG_LOADED_MODULES" ]; then

        VG_LOADED_MODULES="$vg_registry_add_entry"

    else

        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${vg_registry_add_entry}"

    fi


    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))


    return "$VG_SUCCESS"
}



vg_registry_get_path() {

    vg_registry_path_id="$1"


    [ -n "$vg_registry_path_id" ] || return "$VG_ERR_INVALID"


    vg_registry_path_old_ifs="$IFS"
    IFS='
'


    for vg_registry_path_entry in $VG_LOADED_MODULES
    do

        vg_registry_path_entry_id="$(printf '%s\n' "$vg_registry_path_entry" | cut -d'|' -f1)"


        if [ "$vg_registry_path_entry_id" = "$vg_registry_path_id" ]; then

            printf '%s\n' \
                "$(printf '%s\n' "$vg_registry_path_entry" | cut -d'|' -f2)"


            IFS="$vg_registry_path_old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$vg_registry_path_old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



vg_registry_get_dependencies() {

    vg_registry_dep_id="$1"


    [ -n "$vg_registry_dep_id" ] || return "$VG_ERR_INVALID"


    vg_registry_dep_old_ifs="$IFS"
    IFS='
'


    for vg_registry_dep_entry in $VG_LOADED_MODULES
    do

        vg_registry_dep_entry_id="$(printf '%s\n' "$vg_registry_dep_entry" | cut -d'|' -f1)"


        if [ "$vg_registry_dep_entry_id" = "$vg_registry_dep_id" ]; then

            printf '%s\n' \
                "$(printf '%s\n' "$vg_registry_dep_entry" | cut -d'|' -f3)"


            IFS="$vg_registry_dep_old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$vg_registry_dep_old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



vg_registry_reorder() {

    vg_registry_plan="$1"


    [ -n "$vg_registry_plan" ] || return "$VG_ERR_INVALID"


    vg_registry_old_modules="$VG_LOADED_MODULES"


    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0


    vg_registry_plan_old_ifs="$IFS"
    IFS='
'


    for vg_registry_plan_id in $vg_registry_plan
    do


        for vg_registry_old_entry in $vg_registry_old_modules
        do


            vg_registry_old_id="$(printf '%s\n' "$vg_registry_old_entry" | cut -d'|' -f1)"


            if [ "$vg_registry_old_id" = "$vg_registry_plan_id" ]; then


                vg_registry_old_path="$(printf '%s\n' "$vg_registry_old_entry" | cut -d'|' -f2)"
                vg_registry_old_deps="$(printf '%s\n' "$vg_registry_old_entry" | cut -d'|' -f3)"


                vg_registry_add \
                    "$vg_registry_old_id" \
                    "$vg_registry_old_path" \
                    "$vg_registry_old_deps"


                break

            fi

        done


    done


    IFS="$vg_registry_plan_old_ifs"


    return "$VG_SUCCESS"
}
