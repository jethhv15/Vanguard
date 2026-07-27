#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# Policy State
#

VG_RECOVERY_RETRY_COUNT=0
VG_RECOVERY_RETRY_LIMIT=3
VG_RECOVERY_NEXT_ACTION="NONE"



#
# Reset Policy
#

vg_recovery_policy_reset()
{

    VG_RECOVERY_RETRY_COUNT=0
    VG_RECOVERY_NEXT_ACTION="NONE"

    return "$VG_SUCCESS"

}



#
# Determine Next Recovery Action
#

vg_recovery_policy_next_action()
{

    if [ "$VG_RECOVERY_RETRY_COUNT" -lt "$VG_RECOVERY_RETRY_LIMIT" ]; then

        VG_RECOVERY_RETRY_COUNT=$((VG_RECOVERY_RETRY_COUNT + 1))
        VG_RECOVERY_NEXT_ACTION="RETRY_MODULE"

    else

        VG_RECOVERY_NEXT_ACTION="RESTORE_SNAPSHOT"

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

    printf '%s\n' \
        "$VG_RECOVERY_RETRY_LIMIT"

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
