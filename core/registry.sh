#!/system/bin/sh
#
# Project Vanguard
# Registry
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Runtime Storage
#

VG_LOADED_MODULES=""
VG_LOADED_MODULE_COUNT=0


#
# Public API
#

vg_registry_reset() {

    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0

    return "$VG_SUCCESS"
}



vg_registry_add() {

    reg_module_id="$1"
    reg_module_path="$2"
    reg_dependencies="$3"


    [ -n "$reg_module_id" ] || return "$VG_ERR_INVALID"
    [ -n "$reg_module_path" ] || return "$VG_ERR_INVALID"


    if vg_registry_get_path "$reg_module_id" >/dev/null 2>&1; then
        return "$VG_ERR_GENERAL"
    fi


    entry="${reg_module_id}|${reg_module_path}|${reg_dependencies}"


    if [ -z "$VG_LOADED_MODULES" ]; then

        VG_LOADED_MODULES="$entry"

    else

        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${entry}"

    fi


    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))


    return "$VG_SUCCESS"
}



vg_registry_get_path() {

    reg_lookup_id="$1"

    [ -n "$reg_lookup_id" ] || return "$VG_ERR_INVALID"


    old_ifs="$IFS"
    IFS='
'


    for reg_entry in $VG_LOADED_MODULES
    do

        reg_id="$(printf '%s\n' "$reg_entry" | cut -d'|' -f1)"
        reg_path="$(printf '%s\n' "$reg_entry" | cut -d'|' -f2)"


        if [ "$reg_id" = "$reg_lookup_id" ]; then

            IFS="$old_ifs"

            printf '%s\n' "$reg_path"

            return "$VG_SUCCESS"
        fi

    done


    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



vg_registry_get_dependencies() {

    reg_dependency_id="$1"

    [ -n "$reg_dependency_id" ] || return "$VG_ERR_INVALID"


    old_ifs="$IFS"
    IFS='
'


    for reg_entry in $VG_LOADED_MODULES
    do

        reg_id="$(printf '%s\n' "$reg_entry" | cut -d'|' -f1)"


        if [ "$reg_id" = "$reg_dependency_id" ]; then

            printf '%s\n' "$reg_entry" | cut -d'|' -f3

            IFS="$old_ifs"

            return "$VG_SUCCESS"
        fi

    done


    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



#
# Rebuild registry based on startup plan
#

vg_registry_reorder() {

    plan="$1"

    [ -n "$plan" ] || return "$VG_ERR_INVALID"


    old_registry="$VG_LOADED_MODULES"


    VG_LOADED_MODULES=""
    VG_LOADED_MODULE_COUNT=0


    old_ifs="$IFS"
    IFS='
'


    for module_id in $plan
    do

        found="false"


        for entry in $old_registry
        do

            entry_id="$(printf '%s\n' "$entry" | cut -d'|' -f1)"


            if [ "$entry_id" = "$module_id" ]; then

                path="$(printf '%s\n' "$entry" | cut -d'|' -f2)"
                deps="$(printf '%s\n' "$entry" | cut -d'|' -f3)"


                vg_registry_add \
                    "$module_id" \
                    "$path" \
                    "$deps"


                found="true"

                break
            fi

        done


        [ "$found" = "true" ] || {
            IFS="$old_ifs"
            return "$VG_ERR_NOT_FOUND"
        }

    done


    IFS="$old_ifs"


    return "$VG_SUCCESS"
}
