#!/system/bin/sh
#
# Project Vanguard
# Recovery Intelligence Coordinator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# Load intelligence modules
#

[ -f "$CORE_DIR/recovery_decision_engine.sh" ] && \
. "$CORE_DIR/recovery_decision_engine.sh"


[ -f "$CORE_DIR/recovery_transaction_manager.sh" ] && \
. "$CORE_DIR/recovery_transaction_manager.sh"


[ -f "$CORE_DIR/recovery_state_machine.sh" ] && \
. "$CORE_DIR/recovery_state_machine.sh"



#
# State
#

VG_COORD_PATTERN=""
VG_COORD_ACTION=""
VG_COORD_CONFIDENCE=""
VG_COORD_STATE=""
VG_COORD_TRANSACTION=""
VG_COORD_RESULT=""



#
# Reset
#

vg_recovery_coordinator_reset()
{

    VG_COORD_PATTERN=""
    VG_COORD_ACTION=""
    VG_COORD_CONFIDENCE=""
    VG_COORD_STATE="IDLE"
    VG_COORD_TRANSACTION="NONE"
    VG_COORD_RESULT="NONE"

    return "$VG_SUCCESS"

}



#
# Build recovery plan
#

vg_recovery_coordinate()
{

    pattern="$1"
    policy="$2"
    severity="${3:-normal}"



    vg_recovery_coordinator_reset



    VG_COORD_PATTERN="$pattern"



    #
    # Decision
    #

    vg_recovery_decide \
        "$pattern" \
        "$policy" \
        "$severity"



    VG_COORD_ACTION="$VG_DECISION_ACTION"
    VG_COORD_CONFIDENCE="$VG_DECISION_CONFIDENCE"



    #
    # Transaction prepare
    #

    if command -v vg_recovery_transaction_begin >/dev/null 2>&1
    then

        vg_recovery_transaction_begin \
            "$VG_COORD_ACTION"


        VG_COORD_TRANSACTION="$VG_TRANSACTION_ID"

    fi



    #
    # State planning
    #

    if command -v vg_recovery_state_reset >/dev/null 2>&1
    then

        vg_recovery_state_reset

        vg_recovery_state_transition \
            DETECTING

        vg_recovery_state_transition \
            PLANNING


        VG_COORD_STATE="$VG_RECOVERY_STATE"

    fi



    VG_COORD_RESULT="READY"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_coordinate_report()
{

    printf '%s\n' \
        "PATTERN=$VG_COORD_PATTERN"


    printf '%s\n' \
        "ACTION=$VG_COORD_ACTION"


    printf '%s\n' \
        "CONFIDENCE=$VG_COORD_CONFIDENCE"


    printf '%s\n' \
        "STATE=$VG_COORD_STATE"


    printf '%s\n' \
        "TRANSACTION=$VG_COORD_TRANSACTION"


    printf '%s\n' \
        "RESULT=$VG_COORD_RESULT"


    return "$VG_SUCCESS"

}
