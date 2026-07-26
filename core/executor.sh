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
. "$CORE_DIR/audit.sh"


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



vg_executor_audit()
{

    event="$1"
    result="$2"


    command -v vg_audit_write >/dev/null 2>&1 || return "$VG_SUCCESS"


    vg_audit_write \
        "$event" \
        "executor" \
        "" \
        "$VG_EXECUTOR_STATE" \
        "$result" \
        >/dev/null 2>&1


    return "$VG_SUCCESS"

}



#
# Start execution
#

vg_executor_start()
{

    if [ "$VG_EXECUTOR_STATE" = "running" ]; then

        return "$VG_ERR_GENERAL"

    fi



    vg_executor_set_state "starting"



    vg_lifecycle_init

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"


        vg_executor_audit \
            "EXECUTOR_INIT_FAILED" \
            "$rc"


        return "$rc"

    fi



    vg_lifecycle_start

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"


        vg_executor_audit \
            "EXECUTOR_START_FAILED" \
            "$rc"


        return "$rc"

    fi



    vg_executor_set_state "running"



    vg_executor_audit \
        "EXECUTOR_STARTED" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Stop execution
#

vg_executor_stop()
{

    if [ "$VG_EXECUTOR_STATE" != "running" ]; then

        return "$VG_ERR_INVALID"

    fi



    vg_executor_set_state "stopping"



    vg_lifecycle_stop

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_executor_set_state "failed"


        vg_executor_audit \
            "EXECUTOR_STOP_FAILED" \
            "$rc"


        return "$rc"

    fi



    vg_executor_set_state "stopped"



    vg_executor_audit \
        "EXECUTOR_STOPPED" \
        "$VG_SUCCESS"



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
