#!/system/bin/sh
#
# Project Vanguard
# Recovery State Machine Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_state_machine.sh"



#
# Normal flow
#

vg_recovery_state_reset


vg_recovery_state_transition DETECTING


vg_assert_equal \
    "DETECTING" \
    "$VG_RECOVERY_STATE" \
    "Should enter detecting"



vg_recovery_state_transition PLANNING


vg_assert_equal \
    "PLANNING" \
    "$VG_RECOVERY_STATE" \
    "Should enter planning"



vg_recovery_state_transition RECOVERING


vg_recovery_state_transition VERIFYING


vg_recovery_state_complete


vg_assert_equal \
    "COMPLETED" \
    "$VG_RECOVERY_STATE" \
    "Recovery should complete"



#
# Invalid transition
#

vg_recovery_state_reset


vg_recovery_state_transition COMPLETED


vg_assert_equal \
    "$VG_ERR_INVALID" \
    "$?" \
    "Invalid transition should fail"



#
# Rollback
#

vg_recovery_state_reset

vg_recovery_state_transition DETECTING
vg_recovery_state_transition PLANNING
vg_recovery_state_transition RECOVERING
vg_recovery_state_transition VERIFYING

vg_recovery_state_fail


vg_assert_equal \
    "ROLLBACK" \
    "$VG_RECOVERY_STATE" \
    "Failed recovery should rollback"
