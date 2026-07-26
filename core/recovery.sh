#!/system/bin/sh
#
# Project Vanguard
# Audit Recovery Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"


#
# Recovery storage
#

if [ -z "${VG_RECOVERY_DIR:-}" ]; then

    VG_RECOVERY_DIR="$CORE_DIR/../runtime/recovery"

fi


VG_AUDIT_BACKUP="${VG_RECOVERY_DIR}/audit.snapshot"



#
# Prepare recovery storage
#

vg_recovery_prepare()
{

    [ -d "$VG_RECOVERY_DIR" ] || mkdir -p "$VG_RECOVERY_DIR" 2>/dev/null


    [ -d "$VG_RECOVERY_DIR" ] || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Create audit snapshot
#

vg_recovery_snapshot()
{

    vg_recovery_prepare || return $?


    [ -f "$VG_AUDIT_FILE" ] || return "$VG_ERR_NOT_FOUND"



    cp \
        "$VG_AUDIT_FILE" \
        "$VG_AUDIT_BACKUP"


    [ -f "$VG_AUDIT_BACKUP" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Restore audit snapshot
#

vg_recovery_restore()
{

    vg_recovery_prepare || return $?


    [ -f "$VG_AUDIT_BACKUP" ] \
        || return "$VG_ERR_NOT_FOUND"



    cp \
        "$VG_AUDIT_BACKUP" \
        "$VG_AUDIT_FILE"



    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_INTERNAL"



    return "$VG_SUCCESS"

}



#
# Check audit health
#

vg_recovery_check()
{

    vg_audit_verify


    if [ "$?" -eq "$VG_SUCCESS" ]; then

        return "$VG_SUCCESS"

    fi


    return "$VG_ERR_INTERNAL"

}



#
# Execute recovery
#

vg_recovery_execute()
{

    vg_recovery_check


    if [ "$?" -eq "$VG_SUCCESS" ]; then

        return "$VG_SUCCESS"

    fi



    vg_recovery_restore


    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        return "$rc"

    fi



    vg_audit_write \
        "RECOVERY_SUCCESS" \
        "recovery" \
        "corrupt" \
        "restored" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}
