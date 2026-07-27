#!/system/bin/sh
#
# Project Vanguard
# Recovery Escalation Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# Escalation State
#

VG_RECOVERY_ESCALATION_LEVEL=0
VG_RECOVERY_ESCALATION_ACTION="NONE"
VG_RECOVERY_ESCALATION_REASON=""



#
# Reset
#

vg_recovery_escalation_reset()
{

    VG_RECOVERY_ESCALATION_LEVEL=0
    VG_RECOVERY_ESCALATION_ACTION="NONE"
    VG_RECOVERY_ESCALATION_REASON=""

    return "$VG_SUCCESS"

}



#
# Escalate
#

vg_recovery_escalate()
{

    reason="$1"


    VG_RECOVERY_ESCALATION_LEVEL=$(
        expr "$VG_RECOVERY_ESCALATION_LEVEL" + 1
    )



    case "$VG_RECOVERY_ESCALATION_LEVEL" in


        1)

            VG_RECOVERY_ESCALATION_ACTION="RETRY_MODULE"

            ;;


        2)

            VG_RECOVERY_ESCALATION_ACTION="RESTORE_SNAPSHOT"

            ;;


        3|*)

            VG_RECOVERY_ESCALATION_ACTION="ENGINE_FAILED"

            ;;

    esac



    VG_RECOVERY_ESCALATION_REASON="$reason"


    return "$VG_SUCCESS"

}



#
# Get Level
#

vg_recovery_escalation_level()
{

    printf '%s\n' \
        "$VG_RECOVERY_ESCALATION_LEVEL"

    return "$VG_SUCCESS"

}



#
# Get Action
#

vg_recovery_escalation_action()
{

    printf '%s\n' \
        "$VG_RECOVERY_ESCALATION_ACTION"

    return "$VG_SUCCESS"

}



#
# Status
#

vg_recovery_escalation_status()
{

    printf '%s\n' \
        "LEVEL : $VG_RECOVERY_ESCALATION_LEVEL"

    printf '%s\n' \
        "ACTION : $VG_RECOVERY_ESCALATION_ACTION"

    printf '%s\n' \
        "REASON : $VG_RECOVERY_ESCALATION_REASON"

    return "$VG_SUCCESS"

}
