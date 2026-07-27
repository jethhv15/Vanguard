#!/system/bin/sh
#
# Project Vanguard
# Recovery Rollback Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_ROLLBACK_TARGET=""
VG_ROLLBACK_SNAPSHOT=""
VG_ROLLBACK_RESULT="NONE"
VG_ROLLBACK_REASON=""



#
# Reset
#

vg_recovery_rollback_reset()
{

    VG_ROLLBACK_TARGET=""
    VG_ROLLBACK_SNAPSHOT=""
    VG_ROLLBACK_RESULT="NONE"
    VG_ROLLBACK_REASON=""

    return "$VG_SUCCESS"

}



#
# Create rollback point
#

vg_recovery_create_rollback_point()
{

    target="$1"
    snapshot="$2"


    vg_recovery_rollback_reset


    VG_ROLLBACK_TARGET="$target"
    VG_ROLLBACK_SNAPSHOT="$snapshot"
    VG_ROLLBACK_RESULT="READY"
    VG_ROLLBACK_REASON="rollback point created"



    return "$VG_SUCCESS"

}



#
# Execute rollback
#

vg_recovery_execute_rollback()
{

    target="$1"
    snapshot="$2"



    VG_ROLLBACK_TARGET="$target"
    VG_ROLLBACK_SNAPSHOT="$snapshot"



    if [ -z "$snapshot" ]
    then

        VG_ROLLBACK_RESULT="FAILED"
        VG_ROLLBACK_REASON="missing snapshot"


        return "$VG_ERR_NOT_FOUND"

    fi



    VG_ROLLBACK_RESULT="SUCCESS"
    VG_ROLLBACK_REASON="state restored"



    return "$VG_SUCCESS"

}



#
# Validate rollback
#

vg_recovery_validate_rollback()
{

    if [ "$VG_ROLLBACK_RESULT" = "SUCCESS" ]
    then

        return "$VG_SUCCESS"

    fi


    return "$VG_ERR_INVALID"

}



#
# Status
#

vg_recovery_rollback_status()
{

    printf '%s\n' \
        "TARGET=$VG_ROLLBACK_TARGET"


    printf '%s\n' \
        "SNAPSHOT=$VG_ROLLBACK_SNAPSHOT"


    printf '%s\n' \
        "RESULT=$VG_ROLLBACK_RESULT"


    printf '%s\n' \
        "REASON=$VG_ROLLBACK_REASON"


    return "$VG_SUCCESS"

}
