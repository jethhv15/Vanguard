#!/system/bin/sh
#
# Project Vanguard
# Recovery Snapshot Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/snapshot.sh"
. "$CORE_DIR/recovery_snapshot.sh"



#
# Prepare environment
#

VG_SNAPSHOT_DIR="$TEST_DIR/runtime_snapshot"

export VG_SNAPSHOT_DIR


mkdir -p "$VG_SNAPSHOT_DIR"


vg_snapshot_clear



#
# Create snapshot
#

vg_snapshot_create

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Snapshot creation for recovery test"



#
# Restore snapshot
#

vg_recovery_restore_snapshot

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Recovery snapshot restore should complete"



#
# Validate restore state
#

vg_assert_equal \
    "restored" \
    "$(vg_snapshot_status)" \
    "Recovery snapshot should be restored"



#
# Cleanup
#

vg_snapshot_clear
