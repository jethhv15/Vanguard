#!/system/bin/sh
#
# Project Vanguard
# Recovery Execution Orchestrator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# Load modules
#

[ -f "$CORE_DIR/recovery_transaction_manager.sh" ] && \
. "$CORE_DIR/recovery_transaction_manager.sh"


[ -f "$CORE_DIR/recovery_state_machine.sh" ] && \
. "$CORE_DIR/recovery_state_machine.sh"



#
# State
#

VG_EXEC_ACTION=""
VG_EXEC_STATE="IDLE"
VG_EXEC_RESULT="NONE"
VG_EXEC_TRANSACTION=""
VG_EXEC_REASON=""



#
# Reset
#

vg_recovery_execution_reset()
{

    VG_EXEC_ACTION=""
    VG_EXEC_STATE="IDLE"
    VG_EXEC_RESULT="NONE"
    VG_EXEC_TRANSACTION=""
    VG_EXEC_REASON=""

    return "$VG_SUCCESS"

}



#
# Prepare
#

vg_recovery_execution_prepare()
{

    action="$1"


    vg_recovery_execution_reset


    VG_EXEC_ACTION="$action"
    VG_EXEC_STATE="PREPARED"
    VG_EXEC_RESULT="PENDING"



    if command -v vg_recovery_transaction_begin >/dev/null 2>&1
    then

        vg_recovery_transaction_begin "$action"

        VG_EXEC_TRANSACTION="$VG_TRANSACTION_ID"

    fi



    return "$VG_SUCCESS"

}



#
# Execute
#

vg_recovery_execution_run()
{

    if [ "$VG_EXEC_STATE" != "PREPARED" ]
    then

        VG_EXEC_RESULT="FAILED"
        VG_EXEC_REASON="invalid execution state"

        return "$VG_ERR_INVALID"

    fi



    VG_EXEC_STATE="EXECUTING"
    VG_EXEC_RESULT="RUNNING"
    VG_EXEC_REASON="recovery action executing"



    return "$VG_SUCCESS"

}



#
# Verify
#

vg_recovery_execution_verify()
{

    if [ "$VG_EXEC_STATE" != "EXECUTING" ]
    then

        return "$VG_ERR_INVALID"

    fi



    VG_EXEC_STATE="VERIFYING"
    VG_EXEC_RESULT="VERIFY_PENDING"


    return "$VG_SUCCESS"

}



#
# Complete
#

vg_recovery_execution_commit()
{

    if command -v vg_recovery_transaction_commit >/dev/null 2>&1
    then

        vg_recovery_transaction_commit

    fi



    VG_EXEC_STATE="COMPLETED"
    VG_EXEC_RESULT="SUCCESS"
    VG_EXEC_REASON="execution committed"



    return "$VG_SUCCESS"

}



#
# Rollback
#

vg_recovery_execution_rollback()
{

    if command -v vg_recovery_transaction_rollback >/dev/null 2>&1
    then

        vg_recovery_transaction_rollback

    fi



    VG_EXEC_STATE="ROLLED_BACK"
    VG_EXEC_RESULT="FAILED"
    VG_EXEC_REASON="execution rollback"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_execution_report()
{

    printf '%s\n' \
        "ACTION=$VG_EXEC_ACTION"


    printf '%s\n' \
        "STATE=$VG_EXEC_STATE"


    printf '%s\n' \
        "RESULT=$VG_EXEC_RESULT"


    printf '%s\n' \
        "TRANSACTION=$VG_EXEC_TRANSACTION"


    printf '%s\n' \
        "REASON=$VG_EXEC_REASON"

}
