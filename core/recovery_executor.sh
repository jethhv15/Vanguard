#!/system/bin/sh
#
# Project Vanguard
# Recovery Executor
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/dispatcher.sh"
. "$CORE_DIR/audit.sh"


#
# Recovery Execution State
#

VG_RECOVERY_EXECUTION_STATUS="idle"
VG_RECOVERY_EXECUTION_RESULT="$VG_SUCCESS"


#
# Internal
#

vg_recovery_executor_set()
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

    module_id="$1"


    [ -n "$module_id" ] || return "$VG_ERR_INVALID"



    vg_recovery_executor_set \
        "running"



    vg_recovery_executor_audit \
        "RECOVERY_RETRY_START" \
        "$VG_SUCCESS"



    #
    # Stop current module
    #

    vg_dispatch_module \
        "$module_id" \
        stop


    rc=$?



    #
    # Stop failure is ignored if module
    # was already failed
    #

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        current_state="$(vg_state_get_module "$module_id" 2>/dev/null)"


        if [ "$current_state" != "$VG_MODULE_STATE_STOPPED" ]; then

            vg_recovery_executor_audit \
                "RECOVERY_RETRY_STOP_FAILED" \
                "$rc"


            vg_recovery_executor_set \
                "failed"


            return "$rc"

        fi

    fi



    #
    # Init module
    #

    vg_dispatch_module \
        "$module_id" \
        init


    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then


        vg_recovery_executor_audit \
            "RECOVERY_RETRY_INIT_FAILED" \
            "$rc"


        vg_recovery_executor_set \
            "failed"


        return "$rc"

    fi



    #
    # Start module
    #

    vg_dispatch_module \
        "$module_id" \
        start


    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then


        vg_recovery_executor_audit \
            "RECOVERY_RETRY_START_FAILED" \
            "$rc"


        vg_recovery_executor_set \
            "failed"


        return "$rc"

    fi



    vg_recovery_executor_set \
        "completed"



    vg_recovery_executor_audit \
        "RECOVERY_RETRY_SUCCESS" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Public API
#

vg_recovery_execute()
{

    action="${VG_RECOVERY_ACTION:-NONE}"
    target="${VG_RECOVERY_TARGET:-}"


    case "$action" in


        RETRY_MODULE)


            vg_recovery_retry_module \
                "$target"


            return $?


            ;;


        NONE)


            vg_recovery_executor_set \
                "completed"


            return "$VG_SUCCESS"


            ;;


        *)


            vg_recovery_executor_set \
                "failed"


            vg_recovery_executor_audit \
                "RECOVERY_UNSUPPORTED_ACTION" \
                "$VG_ERR_INVALID"


            return "$VG_ERR_INVALID"


            ;;


    esac

}



#
# Status
#

vg_recovery_executor_status()
{

    printf '%s\n' \
        "$VG_RECOVERY_EXECUTION_STATUS"

}
