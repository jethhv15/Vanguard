#!/system/bin/sh
#
# Project Vanguard
# Runtime Controller
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/executor.sh"



#
# Controller State
#

VG_CONTROLLER_STATE="idle"



#
# Start Runtime
#

vg_controller_start()
{

    vg_executor_start

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        VG_CONTROLLER_STATE="failed"

        return "$rc"

    fi


    VG_CONTROLLER_STATE="running"


    return "$VG_SUCCESS"

}



#
# Stop Runtime
#

vg_controller_stop()
{

    vg_executor_stop

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        VG_CONTROLLER_STATE="failed"

        return "$rc"

    fi


    VG_CONTROLLER_STATE="stopped"


    return "$VG_SUCCESS"

}



#
# Restart Runtime
#

vg_controller_restart()
{

    vg_controller_stop

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then
        return "$rc"
    fi



    vg_controller_start

}



#
# Controller Status
#

vg_controller_status()
{

    printf '%s\n' \
        "$VG_CONTROLLER_STATE"

}
