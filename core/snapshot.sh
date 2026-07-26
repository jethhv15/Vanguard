#!/system/bin/sh
#
# Project Vanguard
# Snapshot Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"



#
# Snapshot State
#

VG_SNAPSHOT_STATE="empty"
VG_SNAPSHOT_ID=""


#
# Internal
#

vg_snapshot_prepare()
{

    [ -n "$VG_SNAPSHOT_DIR" ] \
        || return "$VG_ERR_INVALID"


    [ -d "$VG_SNAPSHOT_DIR" ] \
        || mkdir -p "$VG_SNAPSHOT_DIR" 2>/dev/null


    [ -d "$VG_SNAPSHOT_DIR" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Generate ID
#

vg_snapshot_generate_id()
{

    VG_SNAPSHOT_ID="$(date '+%Y%m%d%H%M%S')"


    [ -n "$VG_SNAPSHOT_ID" ] \
        || return "$VG_ERR_INTERNAL"


    printf '%s\n' \
        "$VG_SNAPSHOT_ID"


    return "$VG_SUCCESS"

}



#
# Discover latest snapshot
#

vg_snapshot_discover()
{

    vg_snapshot_prepare || return $?


    latest="$(ls -1 "$VG_SNAPSHOT_DIR"/*.snapshot 2>/dev/null | tail -n 1)"


    [ -n "$latest" ] \
        || return "$VG_ERR_NOT_FOUND"



    VG_SNAPSHOT_ID="$(basename "$latest" .snapshot)"


    return "$VG_SUCCESS"

}



#
# Validate snapshot file
#

vg_snapshot_validate_file()
{

    file="$1"


    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"


    header="$(head -n 1 "$file" 2>/dev/null)"


    [ "$header" = "VANGUARD_SNAPSHOT" ] \
        || return "$VG_ERR_INVALID"


    return "$VG_SUCCESS"

}



#
# Create Snapshot
#

vg_snapshot_create()
{

    vg_snapshot_prepare || return $?


    vg_snapshot_generate_id >/dev/null \
        || return $?



    snapshot_file="$VG_SNAPSHOT_DIR/${VG_SNAPSHOT_ID}.snapshot"



    if [ -f "$snapshot_file" ]; then

        return "$VG_ERR_GENERAL"

    fi



    printf '%s\n' \
        "VANGUARD_SNAPSHOT" \
        "ID=${VG_SNAPSHOT_ID}" \
        "TIME=$(date '+%Y-%m-%d %H:%M:%S')" \
        "STATE=${VG_SNAPSHOT_STATE}" \
        > "$snapshot_file"



    [ -f "$snapshot_file" ] \
        || return "$VG_ERR_INTERNAL"



    vg_snapshot_validate_file "$snapshot_file" \
        || return $?



    VG_SNAPSHOT_STATE="created"



    vg_audit_write \
        "SNAPSHOT_CREATE" \
        "$VG_SNAPSHOT_ID" \
        "empty" \
        "created" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Check Snapshot
#

vg_snapshot_exists()
{

    if [ -z "$VG_SNAPSHOT_ID" ]; then

        vg_snapshot_discover || return $?

    fi



    snapshot_file="$VG_SNAPSHOT_DIR/${VG_SNAPSHOT_ID}.snapshot"


    vg_snapshot_validate_file "$snapshot_file" \
        || return $?



    return "$VG_SUCCESS"

}



#
# Restore
#

vg_snapshot_restore()
{

    vg_snapshot_exists \
        || return $?



    VG_SNAPSHOT_STATE="restored"



    vg_audit_write \
        "SNAPSHOT_RESTORE" \
        "$VG_SNAPSHOT_ID" \
        "created" \
        "restored" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Status
#

vg_snapshot_status()
{

    printf '%s\n' \
        "$VG_SNAPSHOT_STATE"


    return "$VG_SUCCESS"

}



#
# Clear
#

vg_snapshot_clear()
{

    vg_snapshot_prepare || return $?


    rm -f "$VG_SNAPSHOT_DIR"/*.snapshot 2>/dev/null


    VG_SNAPSHOT_STATE="empty"
    VG_SNAPSHOT_ID=""


    return "$VG_SUCCESS"

}
