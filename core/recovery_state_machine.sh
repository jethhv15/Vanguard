#!/system/bin/sh
#
# Project Vanguard
# Recovery State Machine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_RECOVERY_STATE="IDLE"
VG_RECOVERY_RESULT="NONE"
VG_RECOVERY_REASON=""



#
# Reset
#

vg_recovery_state_reset()
{

    VG_RECOVERY_STATE="IDLE"
    VG_RECOVERY_RESULT="NONE"
    VG_RECOVERY_REASON="reset"


    return "$VG_SUCCESS"

}



#
# Transition
#

vg_recovery_state_transition()
{

    next="$1"



    case "$VG_RECOVERY_STATE:$next" in

        IDLE:DETECTING)
            ;;

        DETECTING:PLANNING)
            ;;

        PLANNING:RECOVERING)
            ;;

        RECOVERING:VERIFYING)
            ;;

        VERIFYING:COMPLETED)
            ;;

        VERIFYING:ROLLBACK)
            ;;

        ROLLBACK:VERIFYING)
            ;;

        *)
            VG_RECOVERY_RESULT="INVALID"
            VG_RECOVERY_REASON="invalid transition"

            return "$VG_ERR_INVALID"
            ;;

    esac



    VG_RECOVERY_STATE="$next"
    VG_RECOVERY_RESULT="ACTIVE"
    VG_RECOVERY_REASON="transition success"



    return "$VG_SUCCESS"

}



#
# Complete
#

vg_recovery_state_complete()
{

    VG_RECOVERY_STATE="COMPLETED"
    VG_RECOVERY_RESULT="SUCCESS"
    VG_RECOVERY_REASON="recovery completed"


    return "$VG_SUCCESS"

}



#
# Fail
#

vg_recovery_state_fail()
{

    VG_RECOVERY_STATE="ROLLBACK"
    VG_RECOVERY_RESULT="FAILED"
    VG_RECOVERY_REASON="recovery verification failed"


    return "$VG_SUCCESS"

}



#
# Status
#

vg_recovery_state_status()
{

    printf '%s\n' \
        "STATE=$VG_RECOVERY_STATE"


    printf '%s\n' \
        "RESULT=$VG_RECOVERY_RESULT"


    printf '%s\n' \
        "REASON=$VG_RECOVERY_REASON"


    return "$VG_SUCCESS"

}
