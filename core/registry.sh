#!/system/bin/sh
#
# Project Vanguard
# Module Registry
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Registry Storage
#

VG_REGISTRY_MODULES="${VG_REGISTRY_MODULES:-}"
VG_LOADED_MODULE_COUNT="${VG_LOADED_MODULE_COUNT:-0}"



#
# Reset
#

vg_registry_reset()
{

    VG_REGISTRY_MODULES=""

    VG_LOADED_MODULE_COUNT=0

    return "$VG_SUCCESS"

}



#
# Add
#

vg_registry_add()
{

    module_id="$1"
    module_path="$2"
    module_depends="$3"


    [ -n "$module_id" ] || return "$VG_ERR_INVALID"
    [ -n "$module_path" ] || return "$VG_ERR_INVALID"



    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_REGISTRY_MODULES
    do

        id="${entry%%|*}"


        if [ "$id" = "$module_id" ]; then

            IFS="$old_ifs"

            return "$VG_ERR_GENERAL"

        fi

    done


    IFS="$old_ifs"



    record="${module_id}|${module_path}|${module_depends}"


    if [ -z "$VG_REGISTRY_MODULES" ]; then

        VG_REGISTRY_MODULES="$record"

    else

        VG_REGISTRY_MODULES="${VG_REGISTRY_MODULES}
${record}"

    fi



    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))


    return "$VG_SUCCESS"

}



#
# Get Path
#

vg_registry_get_path()
{

    module_id="$1"


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_REGISTRY_MODULES
    do

        id="${entry%%|*}"

        rest="${entry#*|}"

        path="${rest%%|*}"


        if [ "$id" = "$module_id" ]; then

            printf '%s\n' "$path"

            IFS="$old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$old_ifs"


    return "$VG_ERR_NOT_FOUND"

}



#
# Get Dependencies
#

vg_registry_get_dependencies()
{

    module_id="$1"


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_REGISTRY_MODULES
    do

        id="${entry%%|*}"

        rest="${entry#*|}"

        depends="${rest#*|}"


        if [ "$id" = "$module_id" ]; then

            printf '%s\n' "$depends"

            IFS="$old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$old_ifs"


    return "$VG_ERR_NOT_FOUND"

}



#
# List
#

vg_registry_list()
{

    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_REGISTRY_MODULES
    do

        printf '%s\n' "${entry%%|*}"

    done


    IFS="$old_ifs"

    return "$VG_SUCCESS"

}



#
# Reorder
#

vg_registry_reorder()
{

    plan="$1"

    [ -n "$plan" ] || return "$VG_ERR_INVALID"


    reordered=""


    old_ifs="$IFS"
    IFS='
'


    for module in $plan
    do

        for entry in $VG_REGISTRY_MODULES
        do

            id="${entry%%|*}"


            if [ "$id" = "$module" ]; then


                if [ -z "$reordered" ]; then

                    reordered="$entry"

                else

                    reordered="${reordered}
${entry}"

                fi


            fi

        done

    done


    IFS="$old_ifs"


    VG_REGISTRY_MODULES="$reordered"


    return "$VG_SUCCESS"

}
