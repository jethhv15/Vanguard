#!/system/bin/sh
#
# Project Vanguard
# Recovery Executor
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/lifecycle.sh"
. "$CORE_DIR/dispatcher.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/recovery_transaction.sh"



#
# Recovery Executor State
#

VG_RECOVERY_EXECUTION_STATUS="idle"



#
# Internal
#

vg_recovery_executor_set_status()
{

    VG_RECOVERY_EXECUTION_STATUS="$1"

    return "$VG_SUCCESS"

}



vg_recovery_executor_audit()
{

    event="$1"
    result="$2"


    command -v vg_audit_write >/dev/null 2>&1 || return "$VG_SUCCESS"


    vg_audit_write \
        "$event" \
        "recovery_executor" \
        "" \
        "$VG_RECOVERY_EXECUTION_STATUS" \
        "$result" \
        >/dev/null 2>&1


    return "$VG_SUCCESS"

}



#
# Retry Module
#

vg_recovery_retry_module()
{

    module="$1"


    [ -n "$module" ] || return "$VG_ERR_INVALID"



    #
    # Stop module
    #

    vg_dispatch_module \
        "$module" \
        stop

    rc=$?



    #
    # Stop failure is tolerated
    # because module may already be stopped
    #

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_recovery_executor_audit \
            "RECOVERY_STOP_SKIP" \
            "$rc"

    fi



    #
    # Init module
    #

    vg_dispatch_module \
        "$module" \
        init

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        return "$rc"

    fi



    #
    # Start module
    #

    vg_dispatch_module \
        "$module" \
        start

    rc=$?


    return "$rc"

}



#
# Recovery Execute
#

vg_recovery_execute()
{

    action="${VG_RECOVERY_ACTION:-NONE}"
    target="${VG_RECOVERY_TARGET:-}"



    #
    # Begin transaction
    #

    vg_recovery_tx_begin \
        "$action" \
        "$target"

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_recovery_executor_set_status \
            "failed"

        return "$rc"

    fi



    vg_recovery_executor_set_status \
        "running"



    case "$action" in


        RETRY_MODULE)


            vg_recovery_retry_module \
                "$target"

            rc=$?

            ;;



        NONE)


            rc="$VG_SUCCESS"

            ;;



        *)


            rc="$VG_ERR_INVALID"

            ;;

    esac



    #
    # Commit on success
    #

    if [ "$rc" -eq "$VG_SUCCESS" ]; then


        vg_recovery_tx_commit

        tx_rc=$?


        if [ "$tx_rc" -ne "$VG_SUCCESS" ]; then

            vg_recovery_executor_set_status \
                "failed"

            return "$tx_rc"

        fi



        vg_recovery_executor_set_status \
            "completed"



        vg_recovery_executor_audit \
            "RECOVERY_SUCCESS" \
            "$VG_SUCCESS"



        return "$VG_SUCCESS"

    fi



    #
    # Rollback on failure
    #

    vg_recovery_tx_rollback

    tx_rc=$?



    vg_recovery_executor_set_status \
        "failed"



    vg_recovery_executor_audit \
        "RECOVERY_FAILED" \
        "$rc"



    if [ "$tx_rc" -ne "$VG_SUCCESS" ]; then

        return "$tx_rc"

    fi



    return "$rc"

}



#
# Status
#

vg_recovery_executor_status()
{

    printf '%s\n' \
        "$VG_RECOVERY_EXECUTION_STATUS"

}
