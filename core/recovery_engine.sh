#!/system/bin/sh
#
# Project Vanguard
# Recovery Decision Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_policy.sh"



#
# Recovery State
#

VG_RECOVERY_ACTION="NONE"
VG_RECOVERY_TARGET=""
VG_RECOVERY_LEVEL="none"
VG_RECOVERY_REASON=""


#
# Reset
#

vg_recovery_reset()
{

    VG_RECOVERY_ACTION="NONE"
    VG_RECOVERY_TARGET=""
    VG_RECOVERY_LEVEL="none"
    VG_RECOVERY_REASON=""

    return "$VG_SUCCESS"

}



#
# Setter
#

vg_recovery_set()
{

    VG_RECOVERY_ACTION="$1"
    VG_RECOVERY_TARGET="$2"
    VG_RECOVERY_LEVEL="$3"
    VG_RECOVERY_REASON="$4"

    return "$VG_SUCCESS"

}



#
# Decision Engine
#

vg_recovery_decide()
{

    vg_recovery_reset



    #
    # Module failure
    #

    if [ -n "${VG_DIAGNOSTIC_MODULE:-}" ]; then


        vg_recovery_policy_next_action


        vg_recovery_set \
            "$VG_RECOVERY_NEXT_ACTION" \
            "$VG_DIAGNOSTIC_MODULE" \
            "safe" \
            "module startup failure"


        return "$VG_SUCCESS"

    fi



    #
    # Audit corruption
    #

    if [ "${VG_DIAGNOSTIC_REASON:-}" = "AUDIT_CORRUPTED" ]; then


        vg_recovery_set \
            "RESTORE_SNAPSHOT" \
            "system" \
            "critical" \
            "audit integrity failure"


        return "$VG_SUCCESS"

    fi



    #
    # Runtime invalid
    #

    if [ "${VG_RUNTIME_VALIDATED:-}" != "true" ]; then


        vg_recovery_set \
            "REBOOT_ENGINE" \
            "runtime" \
            "safe" \
            "runtime validation failed"


        return "$VG_SUCCESS"

    fi



    #
    # Health degraded
    #

    if [ "${VG_HEALTH_STATUS:-}" = "degraded" ]; then


        vg_recovery_set \
            "SAFE_MODE" \
            "engine" \
            "safe" \
            "health degraded"


        return "$VG_SUCCESS"

    fi



    #
    # Healthy
    #

    vg_recovery_set \
        "NONE" \
        "" \
        "none" \
        "system healthy"


    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_status()
{

    printf '%s\n' "ACTION : $VG_RECOVERY_ACTION"
    printf '%s\n' "TARGET : $VG_RECOVERY_TARGET"
    printf '%s\n' "LEVEL  : $VG_RECOVERY_LEVEL"
    printf '%s\n' "REASON : $VG_RECOVERY_REASON"

}
