#!/system/bin/sh
#
# Project Vanguard
# Recovery Rollback Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_rollback.sh"



#
# Create rollback point
#

vg_recovery_create_rollback_point \
    "test_module" \
    "snapshot_old"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Rollback point should create"



vg_assert_equal \
    "READY" \
    "$VG_ROLLBACK_RESULT" \
    "Rollback point status"



#
# Execute rollback
#

vg_recovery_execute_rollback \
    "test_module" \
    "snapshot_old"



vg_assert_equal \
    "SUCCESS" \
    "$VG_ROLLBACK_RESULT" \
    "Rollback should succeed"



#
# Validate
#

vg_recovery_validate_rollback



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Rollback validation should pass"



#
# Missing snapshot
#

vg_recovery_execute_rollback \
    "test_module" \
    ""



vg_assert_equal \
    "FAILED" \
    "$VG_ROLLBACK_RESULT" \
    "Missing snapshot should fail"
