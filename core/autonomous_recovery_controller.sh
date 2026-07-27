#!/system/bin/sh
#
# Project Vanguard
# Autonomous Recovery Controller
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_CONTROLLER_ACTION="NONE"
VG_CONTROLLER_LEVEL="none"
VG_CONTROLLER_REASON=""
VG_CONTROLLER_STATUS=""



#
# Reset
#

vg_recovery_controller_reset()
{

    VG_CONTROLLER_ACTION="NONE"
    VG_CONTROLLER_LEVEL="none"
    VG_CONTROLLER_REASON=""
    VG_CONTROLLER_STATUS=""

    return "$VG_SUCCESS"

}



#
# Evaluate Health
#

vg_recovery_controller_evaluate()
{

    failures="$1"
    health="${2:-healthy}"
    loop_count="${3:-0}"



    vg_recovery_controller_reset



    #
    # Loop protection
    #

    if [ "$loop_count" -ge 3 ]
    then

        VG_CONTROLLER_ACTION="QUARANTINE"
        VG_CONTROLLER_LEVEL="critical"
        VG_CONTROLLER_REASON="recovery loop detected"
        VG_CONTROLLER_STATUS="blocked"


        return "$VG_SUCCESS"

    fi



    #
    # Critical health
    #

    if [ "$health" = "critical" ]
    then

        VG_CONTROLLER_ACTION="QUARANTINE"
        VG_CONTROLLER_LEVEL="critical"
        VG_CONTROLLER_REASON="critical health state"
        VG_CONTROLLER_STATUS="approved"


        return "$VG_SUCCESS"

    fi



    #
    # Repeated failure
    #

    if [ "$failures" -ge 5 ]
    then

        VG_CONTROLLER_ACTION="RESTORE"
        VG_CONTROLLER_LEVEL="high"
        VG_CONTROLLER_REASON="failure threshold reached"
        VG_CONTROLLER_STATUS="approved"


        return "$VG_SUCCESS"

    fi



    #
    # Minor failure
    #

    if [ "$failures" -gt 0 ]
    then

        VG_CONTROLLER_ACTION="RETRY"
        VG_CONTROLLER_LEVEL="low"
        VG_CONTROLLER_REASON="temporary failure"
        VG_CONTROLLER_STATUS="approved"


        return "$VG_SUCCESS"

    fi



    VG_CONTROLLER_ACTION="NONE"
    VG_CONTROLLER_LEVEL="none"
    VG_CONTROLLER_REASON="system healthy"
    VG_CONTROLLER_STATUS="idle"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_controller_status()
{

    printf '%s\n' \
        "ACTION=$VG_CONTROLLER_ACTION"


    printf '%s\n' \
        "LEVEL=$VG_CONTROLLER_LEVEL"


    printf '%s\n' \
        "REASON=$VG_CONTROLLER_REASON"


    printf '%s\n' \
        "STATUS=$VG_CONTROLLER_STATUS"


    return "$VG_SUCCESS"

}
