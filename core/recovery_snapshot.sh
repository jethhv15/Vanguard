#!/system/bin/sh
#
# Project Vanguard
# Recovery Snapshot Handler
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/snapshot.sh"



#
# Restore Snapshot Action
#

vg_recovery_restore_snapshot()
{

    snapshot_id="$1"



    if [ -n "$snapshot_id" ]; then

        VG_SNAPSHOT_ID="$snapshot_id"

    fi



    vg_snapshot_exists

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        return "$rc"

    fi



    vg_snapshot_restore

    rc=$?



    return "$rc"

}
