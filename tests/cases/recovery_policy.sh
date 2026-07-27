#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Integration Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_policy.sh"



vg_recovery_policy_reset



#
# Safe severity
#

vg_recovery_policy_set_severity safe


vg_recovery_policy_next_action


vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Safe policy should retry"



vg_assert_equal \
    "1" \
    "$(vg_recovery_policy_retry_count)" \
    "Retry count should increase"



#
# Critical severity
#

vg_recovery_policy_reset


vg_recovery_policy_set_severity critical


vg_recovery_policy_next_action


vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Critical policy should restore"



#
# Limit check
#

vg_recovery_policy_reset


vg_recovery_policy_set_severity safe


vg_recovery_policy_next_action
vg_recovery_policy_next_action
vg_recovery_policy_next_action


vg_recovery_policy_next_action


vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Retry limit should escalate"
