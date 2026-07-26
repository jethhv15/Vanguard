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



vg_lifecycle_update_state()
{

    module="$1"
    state="$2"


    command -v vg_state_set >/dev/null 2>&1 || return "$VG_SUCCESS"


    vg_state_set \
        "$module" \
        "$state" \
        >/dev/null 2>&1


    return "$VG_SUCCESS"

}



vg_lifecycle_rollback()
{

    old_ifs="$IFS"
    IFS='
'


    rollback=""


    for module in $VG_LIFECYCLE_STARTED
    do

        rollback="${module}
${rollback}"

    done



    for module in $rollback
    do

        [ -n "$module" ] || continue


        vg_dispatch_module \
            "$module" \
            stop \
            >/dev/null 2>&1


        vg_lifecycle_update_state \
            "$module" \
            stopped

    done


    IFS="$old_ifs"

}



vg_lifecycle_execute()
{

    action="$1"


    [ -n "$action" ] || return "$VG_ERR_INVALID"


    if [ "$action" = "start" ]; then
        VG_LIFECYCLE_STARTED=""
    fi


    old_ifs="$IFS"
    IFS='
'


    if [ "$action" = "stop" ]; then


        modules=""


        for entry in $VG_LOADED_MODULES
        do

            module_id="${entry%%|*}"

            modules="${module_id}
${modules}"

        done


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



        case "$action" in

            init)

                vg_lifecycle_update_state \
                    "$module_id" \
                    loaded

                ;;


            start)

                vg_lifecycle_update_state \
                    "$module_id" \
                    started


                vg_lifecycle_append_started \
                    "$module_id"

                ;;


            stop)

                vg_lifecycle_update_state \
                    "$module_id" \
                    stopped

                ;;

        esac


    done



    IFS="$old_ifs"


    return "$VG_SUCCESS"

}



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
