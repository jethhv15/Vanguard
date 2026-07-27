#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Optimizer Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_policy_optimizer.sh"



#
# Healthy
#

vg_recovery_policy_optimize \
    0 \
    normal \
    0


vg_assert_equal \
    "IGNORE" \
    "$VG_POLICY_ACTION" \
    "Healthy should ignore"



#
# Retry
#

vg_recovery_policy_optimize \
    1 \
    normal \
    0


vg_assert_equal \
    "RETRY" \
    "$VG_POLICY_ACTION" \
    "Minor failure should retry"



#
# Restore
#

vg_recovery_policy_optimize \
    5 \
    normal \
    0


vg_assert_equal \
    "RESTORE" \
    "$VG_POLICY_ACTION" \
    "Repeated failure should restore"



#
# Critical
#

vg_recovery_policy_optimize \
    1 \
    critical \
    0


vg_assert_equal \
    "QUARANTINE" \
    "$VG_POLICY_ACTION" \
    "Critical should quarantine"
