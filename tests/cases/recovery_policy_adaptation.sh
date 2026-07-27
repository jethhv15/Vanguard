#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Adaptation Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


. "$CORE_DIR/recovery_policy_adaptation.sh"



#
# Strong strategy
#

vg_policy_adapt \
    "RESTORE" \
    95



vg_assert_equal \
    "VERY_HIGH" \
    "$VG_POLICY_PRIORITY" \
    "Successful strategy should increase priority"



vg_assert_equal \
    "95" \
    "$VG_POLICY_CONFIDENCE" \
    "Confidence should increase"



#
# Weak strategy
#

vg_policy_adapt \
    "RETRY" \
    20



vg_assert_equal \
    "LOW" \
    "$VG_POLICY_PRIORITY" \
    "Weak strategy should downgrade"



vg_policy_should_switch \
    "RETRY" \
    "ROLLBACK"



vg_assert_equal \
    "0" \
    "$?" \
    "Weak strategy should recommend switch"
