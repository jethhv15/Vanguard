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


#
# Policy State
#

VG_RECOVERY_RETRY_COUNT=0
VG_RECOVERY_RETRY_LIMIT=3
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
# Decide Action
#

vg_recovery_policy_next_action()
{


    limit="$(vg_recovery_rules_retry_limit "$VG_RECOVERY_SEVERITY")"



    if [ "$VG_RECOVERY_RETRY_COUNT" -lt "$limit" ]; then


        VG_RECOVERY_RETRY_COUNT=$((VG_RECOVERY_RETRY_COUNT + 1))


        vg_recovery_rules_resolve \
            "$VG_RECOVERY_SEVERITY"


        VG_RECOVERY_NEXT_ACTION="$VG_RECOVERY_RULE_ACTION"



    else


        VG_RECOVERY_NEXT_ACTION="RESTORE_SNAPSHOT"



    fi


    return "$VG_SUCCESS"

}



#
# State Getters
#

vg_recovery_policy_retry_count()
{

    printf '%s\n' \
        "$VG_RECOVERY_RETRY_COUNT"

}



vg_recovery_policy_retry_limit()
{

    vg_recovery_rules_retry_limit \
        "$VG_RECOVERY_SEVERITY"

}



vg_recovery_policy_current_action()
{

    printf '%s\n' \
        "$VG_RECOVERY_NEXT_ACTION"

}
