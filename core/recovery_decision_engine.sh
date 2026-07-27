#!/system/bin/sh
#
# Project Vanguard
# Recovery Decision Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/recovery_knowledge_integrator.sh" ] && \
. "$CORE_DIR/recovery_knowledge_integrator.sh"



#
# State
#

VG_DECISION_ACTION="NONE"
VG_DECISION_PRIORITY="NONE"
VG_DECISION_CONFIDENCE="0"
VG_DECISION_SOURCE="NONE"
VG_DECISION_REASON=""



#
# Reset
#

vg_recovery_decision_reset()
{

    VG_DECISION_ACTION="NONE"
    VG_DECISION_PRIORITY="NONE"
    VG_DECISION_CONFIDENCE="0"
    VG_DECISION_SOURCE="NONE"
    VG_DECISION_REASON=""

    return "$VG_SUCCESS"

}



#
# Decide
#

vg_recovery_decide()
{

    pattern="$1"
    policy_action="$2"
    severity="${3:-normal}"



    vg_recovery_decision_reset



    #
    # Knowledge first
    #

    if command -v vg_recovery_integrate_knowledge >/dev/null 2>&1
    then

        vg_recovery_integrate_knowledge \
            "$pattern" \
            "$policy_action"



        VG_DECISION_ACTION="$VG_INTEGRATOR_ACTION"
        VG_DECISION_SOURCE="$VG_INTEGRATOR_SOURCE"


        if [ "$VG_INTEGRATOR_CONFIDENCE" = "HIGH" ]
        then
            VG_DECISION_CONFIDENCE=90
        else
            VG_DECISION_CONFIDENCE=60
        fi


    else

        VG_DECISION_ACTION="$policy_action"
        VG_DECISION_SOURCE="policy"
        VG_DECISION_CONFIDENCE=50

    fi



    #
    # Severity override
    #

    if [ "$severity" = "critical" ]
    then

        VG_DECISION_ACTION="QUARANTINE"
        VG_DECISION_PRIORITY="CRITICAL"
        VG_DECISION_CONFIDENCE=95
        VG_DECISION_SOURCE="severity"
        VG_DECISION_REASON="critical failure override"


        return "$VG_SUCCESS"

    fi



    case "$VG_DECISION_ACTION" in

        QUARANTINE)
            VG_DECISION_PRIORITY="HIGH"
            ;;

        RESTORE)
            VG_DECISION_PRIORITY="HIGH"
            ;;

        RETRY)
            VG_DECISION_PRIORITY="MEDIUM"
            ;;

        IGNORE)
            VG_DECISION_PRIORITY="LOW"
            ;;

    esac



    VG_DECISION_REASON="decision generated"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_decision_report()
{

    printf '%s\n' \
        "ACTION=$VG_DECISION_ACTION"


    printf '%s\n' \
        "PRIORITY=$VG_DECISION_PRIORITY"


    printf '%s\n' \
        "CONFIDENCE=$VG_DECISION_CONFIDENCE"


    printf '%s\n' \
        "SOURCE=$VG_DECISION_SOURCE"


    printf '%s\n' \
        "REASON=$VG_DECISION_REASON"

}
