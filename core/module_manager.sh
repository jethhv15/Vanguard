#!/system/bin/sh
#
# Project Vanguard
# Module Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/dispatcher.sh"



#
# Check module existence
#

vg_module_exists()
{

    module_id="$1"


    [ -n "$module_id" ] || return "$VG_ERR_INVALID"


    vg_registry_get_path "$module_id" >/dev/null 2>&1


    return $?

}



#
# List registered modules
#

vg_module_list()
{

    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_LOADED_MODULES
    do

        module_id="${entry%%|*}"


        [ -n "$module_id" ] || continue


        printf '%s\n' "$module_id"

    done


    IFS="$old_ifs"


    return "$VG_SUCCESS"

}



#
# Module information
#

vg_module_info()
{

    module_id="$1"


    [ -n "$module_id" ] || return "$VG_ERR_INVALID"


    vg_registry_get_path "$module_id"

}



#
# Start single module
#

vg_module_start()
{

    module_id="$1"


    vg_module_exists "$module_id" || return $?



    #
    # Prepare module state
    #

    vg_dispatch_module \
        "$module_id" \
        init || return $?



    #
    # Start module
    #

    vg_dispatch_module \
        "$module_id" \
        start



}



#
# Stop single module
#

vg_module_stop()
{

    module_id="$1"


    vg_module_exists "$module_id" || return $?



    vg_dispatch_module \
        "$module_id" \
        stop



}



#
# Restart single module
#

vg_module_restart()
{

    module_id="$1"


    vg_module_exists "$module_id" || return $?



    vg_module_stop \
        "$module_id" || return $?



    vg_module_start \
        "$module_id"



}



#
# Module status placeholder
#
# Future:
# per-module state tracking
#

vg_module_status()
{

    module_id="$1"


    vg_module_exists "$module_id" || return $?


    printf '%s\n' \
        "registered"


    return "$VG_SUCCESS"

}
