#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Optimizer
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_POLICY_ACTION="NONE"
VG_POLICY_CONFIDENCE="NONE"
VG_POLICY_REASON=""
VG_POLICY_PRIORITY="NONE"



#
# Reset
#

vg_recovery_policy_reset()
{

    VG_POLICY_ACTION="NONE"
    VG_POLICY_CONFIDENCE="NONE"
    VG_POLICY_REASON=""
    VG_POLICY_PRIORITY="NONE"

    return "$VG_SUCCESS"

}



#
# Optimize decision
#

vg_recovery_policy_optimize()
{

    failures="$1"
    severity="${2:-normal}"
    history="${3:-0}"



    vg_recovery_policy_reset



    #
    # Critical
    #

    if [ "$severity" = "critical" ]
    then

        VG_POLICY_ACTION="QUARANTINE"
        VG_POLICY_CONFIDENCE="HIGH"
        VG_POLICY_PRIORITY="CRITICAL"
        VG_POLICY_REASON="critical failure detected"


        return "$VG_SUCCESS"

    fi



    #
    # Repeated failure
    #

    if [ "$failures" -ge 5 ]
    then

        VG_POLICY_ACTION="RESTORE"
        VG_POLICY_CONFIDENCE="HIGH"
        VG_POLICY_PRIORITY="HIGH"
        VG_POLICY_REASON="failure threshold exceeded"


        return "$VG_SUCCESS"

    fi



    #
    # Previous recovery failed
    #

    if [ "$history" -gt 2 ]
    then

        VG_POLICY_ACTION="QUARANTINE"
        VG_POLICY_CONFIDENCE="MEDIUM"
        VG_POLICY_PRIORITY="HIGH"
        VG_POLICY_REASON="repeated recovery failure"


        return "$VG_SUCCESS"

    fi



    #
    # Temporary issue
    #

    if [ "$failures" -gt 0 ]
    then

        VG_POLICY_ACTION="RETRY"
        VG_POLICY_CONFIDENCE="HIGH"
        VG_POLICY_PRIORITY="LOW"
        VG_POLICY_REASON="temporary failure"


        return "$VG_SUCCESS"

    fi



    VG_POLICY_ACTION="IGNORE"
    VG_POLICY_CONFIDENCE="HIGH"
    VG_POLICY_PRIORITY="NONE"
    VG_POLICY_REASON="healthy state"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_policy_report()
{

    printf '%s\n' \
        "ACTION=$VG_POLICY_ACTION"


    printf '%s\n' \
        "CONFIDENCE=$VG_POLICY_CONFIDENCE"


    printf '%s\n' \
        "PRIORITY=$VG_POLICY_PRIORITY"


    printf '%s\n' \
        "REASON=$VG_POLICY_REASON"


    return "$VG_SUCCESS"

}
