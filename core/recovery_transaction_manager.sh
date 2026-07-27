#!/system/bin/sh
#
# Project Vanguard
# Recovery Transaction Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_TRANSACTION_ID=""
VG_TRANSACTION_STATE="IDLE"
VG_TRANSACTION_ACTION=""
VG_TRANSACTION_RESULT="NONE"
VG_TRANSACTION_REASON=""



#
# Reset
#

vg_recovery_transaction_reset()
{

    VG_TRANSACTION_ID=""
    VG_TRANSACTION_STATE="IDLE"
    VG_TRANSACTION_ACTION=""
    VG_TRANSACTION_RESULT="NONE"
    VG_TRANSACTION_REASON=""

    return "$VG_SUCCESS"

}



#
# Begin
#

vg_recovery_transaction_begin()
{

    action="$1"


    vg_recovery_transaction_reset



    VG_TRANSACTION_ID="txn_$(date '+%Y%m%d%H%M%S')"
    VG_TRANSACTION_STATE="ACTIVE"
    VG_TRANSACTION_ACTION="$action"
    VG_TRANSACTION_RESULT="PENDING"
    VG_TRANSACTION_REASON="transaction started"



    return "$VG_SUCCESS"

}



#
# Commit
#

vg_recovery_transaction_commit()
{

    if [ "$VG_TRANSACTION_STATE" != "ACTIVE" ]
    then

        VG_TRANSACTION_RESULT="FAILED"
        VG_TRANSACTION_REASON="invalid transaction state"

        return "$VG_ERR_INVALID"

    fi



    VG_TRANSACTION_STATE="COMMITTED"
    VG_TRANSACTION_RESULT="SUCCESS"
    VG_TRANSACTION_REASON="transaction committed"



    return "$VG_SUCCESS"

}



#
# Rollback
#

vg_recovery_transaction_rollback()
{

    VG_TRANSACTION_STATE="ROLLED_BACK"
    VG_TRANSACTION_RESULT="SUCCESS"
    VG_TRANSACTION_REASON="transaction rollback completed"



    return "$VG_SUCCESS"

}



#
# Verify state
#

vg_recovery_transaction_verify()
{

    if [ "$VG_TRANSACTION_STATE" = "COMMITTED" ]
    then

        return "$VG_SUCCESS"

    fi


    return "$VG_ERR_INVALID"

}



#
# Status
#

vg_recovery_transaction_status()
{

    printf '%s\n' \
        "ID=$VG_TRANSACTION_ID"


    printf '%s\n' \
        "STATE=$VG_TRANSACTION_STATE"


    printf '%s\n' \
        "ACTION=$VG_TRANSACTION_ACTION"


    printf '%s\n' \
        "RESULT=$VG_TRANSACTION_RESULT"


    printf '%s\n' \
        "REASON=$VG_TRANSACTION_REASON"

}
