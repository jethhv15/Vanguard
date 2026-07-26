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
# Snapshot Storage
#

if [ -z "${VG_RUNTIME_DIR:-}" ]; then

    VG_RUNTIME_DIR="$CORE_DIR/../runtime"

fi


VG_SNAPSHOT_DIR="$VG_RUNTIME_DIR/snapshot"


VG_SNAPSHOT_STATE="empty"
VG_SNAPSHOT_ID=""


#
# Internal
#

vg_snapshot_prepare()
{

    [ -d "$VG_SNAPSHOT_DIR" ] || mkdir -p "$VG_SNAPSHOT_DIR"


    [ -d "$VG_SNAPSHOT_DIR" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



vg_snapshot_generate_id()
{

    VG_SNAPSHOT_ID="$(date '+%Y%m%d%H%M%S')"


    printf '%s\n' \
        "$VG_SNAPSHOT_ID"

}



#
# Public API
#

vg_snapshot_create()
{

    vg_snapshot_prepare || return $?


    vg_snapshot_generate_id >/dev/null


    snapshot_file="$VG_SNAPSHOT_DIR/${VG_SNAPSHOT_ID}.snapshot"



    printf '%s\n' \
        "VANGUARD_SNAPSHOT" \
        "ID=${VG_SNAPSHOT_ID}" \
        "TIME=$(date '+%Y-%m-%d %H:%M:%S')" \
        "STATE=${VG_SNAPSHOT_STATE}" \
        > "$snapshot_file"



    if [ ! -f "$snapshot_file" ]; then

        return "$VG_ERR_INTERNAL"

    fi



    VG_SNAPSHOT_STATE="created"



    vg_audit_write \
        "SNAPSHOT_CREATE" \
        "$VG_SNAPSHOT_ID" \
        "empty" \
        "created" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_snapshot_exists()
{

    [ -n "$VG_SNAPSHOT_ID" ] \
        || return "$VG_ERR_NOT_FOUND"



    [ -f "$VG_SNAPSHOT_DIR/${VG_SNAPSHOT_ID}.snapshot" ] \
        || return "$VG_ERR_NOT_FOUND"



    return "$VG_SUCCESS"

}



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



vg_snapshot_status()
{

    printf '%s\n' \
        "$VG_SNAPSHOT_STATE"


    return "$VG_SUCCESS"

}



vg_snapshot_clear()
{

    vg_snapshot_prepare || return $?


    rm -f "$VG_SNAPSHOT_DIR"/*.snapshot 2>/dev/null


    VG_SNAPSHOT_STATE="empty"
    VG_SNAPSHOT_ID=""


    return "$VG_SUCCESS"

}
