#!/system/bin/sh
#
# Project Vanguard
# Self Healing Executor Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/self_healing_executor.sh"



#
# Retry
#

vg_self_heal_execute_action \
    "RETRY" \
    "test_module"



vg_assert_equal \
    "SUCCESS" \
    "$VG_EXEC_RESULT" \
    "Retry execution should succeed"



vg_assert_equal \
    "RETRY" \
    "$VG_EXEC_ACTION" \
    "Retry action"



#
# Restore
#

vg_self_heal_execute_action \
    "RESTORE" \
    "test_module"



vg_assert_equal \
    "RESTORE" \
    "$VG_EXEC_ACTION" \
    "Restore action"



#
# Quarantine
#

vg_self_heal_execute_action \
    "QUARANTINE" \
    "test_module"



vg_assert_equal \
    "QUARANTINE" \
    "$VG_EXEC_ACTION" \
    "Quarantine action"



#
# Invalid
#

vg_self_heal_execute_action \
    "INVALID" \
    "test_module"



vg_assert_equal \
    "FAILED" \
    "$VG_EXEC_RESULT" \
    "Invalid action should fail"
