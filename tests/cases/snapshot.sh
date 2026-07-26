#!/system/bin/sh
#
# Project Vanguard
# Snapshot Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/snapshot.sh"



vg_snapshot_clear



state="$(vg_snapshot_status)"

vg_assert_equal \
"empty" \
"$state" \
"Snapshot initial state"



vg_snapshot_create

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Snapshot create completed"



exists="$(vg_snapshot_exists)"

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Snapshot exists"



state="$(vg_snapshot_status)"

vg_assert_equal \
"created" \
"$state" \
"Snapshot created state"



vg_snapshot_restore

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Snapshot restore completed"



state="$(vg_snapshot_status)"

vg_assert_equal \
"restored" \
"$state" \
"Snapshot restored state"



vg_snapshot_clear

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Snapshot clear completed"
