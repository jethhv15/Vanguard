#!/system/bin/sh
#
# Project Vanguard
# Quarantine Recovery Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/quarantine.sh" ] && . "$CORE_DIR/quarantine.sh"



#
# State
#

VG_RECOVERY_MODULE=""
VG_RECOVERY_STATUS="idle"
VG_RECOVERY_REASON=""



#
# Reset
#

vg_quarantine_recovery_reset()
{

    VG_RECOVERY_MODULE=""
    VG_RECOVERY_STATUS="idle"
    VG_RECOVERY_REASON=""

    return "$VG_SUCCESS"

}



#
# Validate Restore
#

vg_quarantine_validate_restore()
{

    module="$1"


    [ -d "$module" ] \
        || return "$VG_ERR_NOT_FOUND"



    [ -f "$module/module.prop" ] \
        || return "$VG_ERR_INVALID"



    return "$VG_SUCCESS"

}



#
# Restore
#

vg_quarantine_restore()
{

    module="$1"


    vg_quarantine_validate_restore "$module" \
        || return $?



    VG_RECOVERY_MODULE="$module"
    VG_RECOVERY_STATUS="restored"
    VG_RECOVERY_REASON="validation passed"



    return "$VG_SUCCESS"

}



#
# Recover
#

vg_quarantine_recover()
{

    module="$1"


    vg_quarantine_recovery_reset



    VG_RECOVERY_MODULE="$module"



    vg_quarantine_restore "$module"

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]
    then

        VG_RECOVERY_STATUS="failed"
        VG_RECOVERY_REASON="restore validation failed"


        return "$rc"

    fi



    vg_quarantine_remove "$module"



    VG_RECOVERY_STATUS="recovered"
    VG_RECOVERY_REASON="quarantine released"



    return "$VG_SUCCESS"

}



#
# Status
#

vg_quarantine_recovery_status()
{

    printf '%s\n' \
        "MODULE=$VG_RECOVERY_MODULE"


    printf '%s\n' \
        "STATUS=$VG_RECOVERY_STATUS"


    printf '%s\n' \
        "REASON=$VG_RECOVERY_REASON"


    return "$VG_SUCCESS"

}
