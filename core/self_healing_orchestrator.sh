#!/system/bin/sh
#
# Project Vanguard
# Self Healing Orchestrator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/self_healing_policy.sh" ] && . "$CORE_DIR/self_healing_policy.sh"
[ -f "$CORE_DIR/self_healing_executor.sh" ] && . "$CORE_DIR/self_healing_executor.sh"



#
# State
#

VG_ORCH_MODULE=""
VG_ORCH_DECISION=""
VG_ORCH_RESULT=""
VG_ORCH_REASON=""



#
# Reset
#

vg_self_heal_orchestrator_reset()
{

    VG_ORCH_MODULE=""
    VG_ORCH_DECISION=""
    VG_ORCH_RESULT=""
    VG_ORCH_REASON=""

    return "$VG_SUCCESS"

}



#
# Pipeline
#

vg_self_heal_orchestrate()
{

    module="$1"
    failures="$2"
    critical="${3:-false}"


    vg_self_heal_orchestrator_reset



    VG_ORCH_MODULE="$module"



    #
    # Decision
    #

    vg_self_heal_decide \
        "$failures" \
        "$critical"


    VG_ORCH_DECISION="$VG_HEAL_ACTION"



    #
    # Execute
    #

    vg_self_heal_execute_action \
        "$VG_HEAL_ACTION" \
        "$module"



    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]
    then

        VG_ORCH_RESULT="FAILED"
        VG_ORCH_REASON="$VG_EXEC_REASON"


        return "$rc"

    fi



    VG_ORCH_RESULT="$VG_EXEC_RESULT"
    VG_ORCH_REASON="$VG_EXEC_REASON"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_self_heal_report()
{

    printf '%s\n' \
        "MODULE=$VG_ORCH_MODULE"


    printf '%s\n' \
        "DECISION=$VG_ORCH_DECISION"


    printf '%s\n' \
        "RESULT=$VG_ORCH_RESULT"


    printf '%s\n' \
        "REASON=$VG_ORCH_REASON"



    return "$VG_SUCCESS"

}
