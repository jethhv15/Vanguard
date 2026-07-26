#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/dispatcher.sh"
. "$CORE_DIR/state.sh"


#
# Internal
#

VG_LIFECYCLE_STARTED=""


vg_lifecycle_append_started()
{

    module_id="$1"


    if [ -z "$VG_LIFECYCLE_STARTED" ]; then

        VG_LIFECYCLE_STARTED="$module_id"

    else

        VG_LIFECYCLE_STARTED="${VG_LIFECYCLE_STARTED}
${module_id}"

    fi


}



vg_lifecycle_rollback()
{

    old_ifs="$IFS"
    IFS='
'


    rollback_list=""


    for module in $VG_LIFECYCLE_STARTED
    do

        if [ -z "$rollback_list" ]; then

            rollback_list="$module"

        else

            rollback_list="${module}
${rollback_list}"

        fi

    done



    for module in $rollback_list
    do

        [ -n "$module" ] || continue

        vg_dispatch_module \
            "$module" \
            stop >/dev/null 2>&1

    done


    IFS="$old_ifs"

}



vg_lifecycle_execute()
{

    action="$1"


    [ -n "$action" ] || return "$VG_ERR_INVALID"


    VG_LIFECYCLE_STARTED=""


    old_ifs="$IFS"
    IFS='
'


    #
    # Start order follows registry planner result
    #

    if [ "$action" = "stop" ]; then

        reverse_list=""

        for entry in $VG_LOADED_MODULES
        do

            module_id="${entry%%|*}"

            if [ -z "$reverse_list" ]; then

                reverse_list="$module_id"

            else

                reverse_list="${module_id}
${reverse_list}"

            fi

        done


        modules="$reverse_list"

    else

        modules="$VG_LOADED_MODULES"

    fi



    for entry in $modules
    do

        module_id="${entry%%|*}"


        [ -n "$module_id" ] || continue



        vg_dispatch_module \
            "$module_id" \
            "$action"

        rc=$?



        if [ "$rc" -ne "$VG_SUCCESS" ]; then


            if [ "$action" = "start" ]; then

                vg_lifecycle_rollback

            fi


            IFS="$old_ifs"

            return "$rc"

        fi



        if [ "$action" = "start" ]; then

            vg_lifecycle_append_started "$module_id"

        fi


    done



    IFS="$old_ifs"


    return "$VG_SUCCESS"

}



#
# Public API
#

vg_lifecycle_init()
{

    vg_lifecycle_execute init

}



vg_lifecycle_start()
{

    vg_lifecycle_execute start

}



vg_lifecycle_stop()
{

    vg_lifecycle_execute stop

}
