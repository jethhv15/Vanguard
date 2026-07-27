#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_policy.sh"



#
# Reset Policy
#

vg_recovery_policy_reset



#
# Initial State
#

vg_assert_equal \
    "0" \
    "$(vg_recovery_policy_retry_count)" \
    "Retry counter should start at zero"

vg_assert_equal \
    "NONE" \
    "$(vg_recovery_policy_current_action)" \
    "Initial recovery action"



#
# First Retry
#

vg_recovery_policy_next_action

vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "First recovery action"



#
# Second Retry
#

vg_recovery_policy_next_action

vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Second recovery action"



#
# Third Retry
#

vg_recovery_policy_next_action

vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Third recovery action"



#
# Fallback
#

vg_recovery_policy_next_action

vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_NEXT_ACTION" \
    "Fallback recovery action"



#
# Counter Validation
#

vg_assert_equal \
    "3" \
    "$(vg_recovery_policy_retry_count)" \
    "Retry counter should stop at limit"



#
# Retry Limit Validation
#

vg_assert_equal \
    "3" \
    "$(vg_recovery_policy_retry_limit)" \
    "Retry limit should be three"
