#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Escalation Integration Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_policy.sh"



#
# Reset
#

vg_recovery_policy_reset



#
# Safe retry flow
#

vg_recovery_policy_set_severity safe


vg_recovery_policy_next_action

vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "First retry should use module retry"



vg_recovery_policy_next_action

vg_recovery_policy_next_action



#
# Escalation
#

vg_recovery_policy_next_action


vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Retry limit should escalate"



vg_assert_equal \
    "2" \
    "$VG_RECOVERY_ESCALATION_LEVEL" \
    "Escalation level should reach snapshot recovery"
