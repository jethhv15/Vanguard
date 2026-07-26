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

VG_AUDIT_BACKUP="${VG_RECOVERY_DIR}/audit.snapshot"



#
# Prepare recovery storage
#

vg_recovery_prepare()
{

    [ -n "$VG_RECOVERY_DIR" ] \
        || return "$VG_ERR_INVALID"


    [ -d "$VG_RECOVERY_DIR" ] \
        || mkdir -p "$VG_RECOVERY_DIR" 2>/dev/null


    [ -d "$VG_RECOVERY_DIR" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Validate backup
#

vg_recovery_validate_backup()
{

    file="$1"


    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"


    [ -s "$file" ] \
        || return "$VG_ERR_INVALID"


    return "$VG_SUCCESS"

}



#
# Create audit snapshot
#

vg_recovery_snapshot()
{

    vg_recovery_prepare || return $?


    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    [ -s "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_INVALID"



    cp \
        "$VG_AUDIT_FILE" \
        "$VG_AUDIT_BACKUP"


    rc=$?


    [ "$rc" -eq "$VG_SUCCESS" ] \
        || return "$VG_ERR_INTERNAL"



    vg_recovery_validate_backup "$VG_AUDIT_BACKUP" \
        || return $?



    return "$VG_SUCCESS"

}



#
# Restore audit snapshot
#

vg_recovery_restore()
{

    vg_recovery_prepare || return $?


    vg_recovery_validate_backup "$VG_AUDIT_BACKUP" \
        || return $?



    temp_file="${VG_AUDIT_FILE}.restore"



    cp \
        "$VG_AUDIT_BACKUP" \
        "$temp_file"


    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        rm -f "$temp_file" 2>/dev/null

        return "$VG_ERR_INTERNAL"

    fi



    [ -s "$temp_file" ] \
        || {

            rm -f "$temp_file" 2>/dev/null

            return "$VG_ERR_INVALID"

        }



    mv \
        "$temp_file" \
        "$VG_AUDIT_FILE"


    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        rm -f "$temp_file" 2>/dev/null

        return "$VG_ERR_INTERNAL"

    fi



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
