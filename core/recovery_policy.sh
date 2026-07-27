#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_rules.sh"
. "$CORE_DIR/recovery_escalation.sh"



#
# Policy State
#

VG_RECOVERY_RETRY_COUNT=0
VG_RECOVERY_NEXT_ACTION="NONE"
VG_RECOVERY_SEVERITY="safe"



#
# Reset
#

vg_recovery_policy_reset()
{

    VG_RECOVERY_RETRY_COUNT=0
    VG_RECOVERY_NEXT_ACTION="NONE"
    VG_RECOVERY_SEVERITY="safe"

    vg_recovery_escalation_reset

    return "$VG_SUCCESS"

}



#
# Set Severity
#

vg_recovery_policy_set_severity()
{

    VG_RECOVERY_SEVERITY="$1"

    return "$VG_SUCCESS"

}



#
# Decide Next Action
#

vg_recovery_policy_next_action()
{

    limit="$(vg_recovery_rules_retry_limit "$VG_RECOVERY_SEVERITY")"



    #
    # Critical bypass retry
    #

    if [ "$VG_RECOVERY_SEVERITY" = "critical" ]
    then

        vg_recovery_rules_resolve \
            "$VG_RECOVERY_SEVERITY"


        VG_RECOVERY_NEXT_ACTION="$VG_RECOVERY_RULE_ACTION"


        return "$VG_SUCCESS"

    fi



    #
    # Retry path
    #

    if [ "$VG_RECOVERY_RETRY_COUNT" -lt "$limit" ]
    then


        VG_RECOVERY_RETRY_COUNT=$((VG_RECOVERY_RETRY_COUNT + 1))


        vg_recovery_rules_resolve \
            "$VG_RECOVERY_SEVERITY"


        VG_RECOVERY_NEXT_ACTION="$VG_RECOVERY_RULE_ACTION"



    else


        #
        # Retry exhausted
        #

        vg_recovery_escalate \
            "retry limit exceeded"



        #
        # Phase 5.6:
        # Consume retry escalation
        # until snapshot recovery
        #

        if [ "$VG_RECOVERY_ESCALATION_ACTION" = "RETRY_MODULE" ]
        then

            vg_recovery_escalate \
                "escalating after retry exhaustion"

        fi



        VG_RECOVERY_NEXT_ACTION="$VG_RECOVERY_ESCALATION_ACTION"



    fi



    return "$VG_SUCCESS"

}



#
# Get Retry Count
#

vg_recovery_policy_retry_count()
{

    printf '%s\n' \
        "$VG_RECOVERY_RETRY_COUNT"


    return "$VG_SUCCESS"

}



#
# Get Retry Limit
#

vg_recovery_policy_retry_limit()
{

    vg_recovery_rules_retry_limit \
        "$VG_RECOVERY_SEVERITY"


    return "$VG_SUCCESS"

}



#
# Get Current Action
#

vg_recovery_policy_current_action()
{

    printf '%s\n' \
        "$VG_RECOVERY_NEXT_ACTION"


    return "$VG_SUCCESS"

}
