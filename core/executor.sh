#!/system/bin/sh
#
# Project Vanguard
# Executor Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/lifecycle.sh"



#
# Executor State
#

VG_EXECUTOR_STATE="idle"



#
# Internal
#

vg_executor_set_state()
{

    VG_EXECUTOR_STATE="$1"

    return "$VG_SUCCESS"

}



#
# Start execution
#

vg_executor_start()
{

    vg_executor_set_state "starting"



    vg_lifecycle_init

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"

        return "$rc"

    fi



    vg_lifecycle_start

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"

        return "$rc"

    fi



    vg_executor_set_state "running"



    return "$VG_SUCCESS"

}



#
# Stop execution
#

vg_executor_stop()
{

    vg_executor_set_state "stopping"



    vg_lifecycle_stop

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"

        return "$rc"

    fi



    vg_executor_set_state "stopped"



    return "$VG_SUCCESS"

}



#
# Get executor state
#

vg_executor_status()
{

    printf '%s\n' \
        "$VG_EXECUTOR_STATE"

}
