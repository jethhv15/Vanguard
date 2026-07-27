#!/system/bin/sh
#
# Project Vanguard
# Recovery Learning Engine Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_learning_engine.sh"



#
# Successful strategy
#

vg_recovery_learning_analyze \
    "RESTORE" \
    10 \
    9



vg_assert_equal \
    "RESTORE" \
    "$VG_LEARNING_RECOMMENDATION" \
    "Effective strategy should remain"



#
# Bad retry strategy
#

vg_recovery_learning_analyze \
    "RETRY" \
    10 \
    2



vg_assert_equal \
    "RESTORE" \
    "$VG_LEARNING_RECOMMENDATION" \
    "Bad retry should recommend restore"



#
# Acceptable strategy
#

vg_recovery_learning_analyze \
    "RESTORE" \
    10 \
    5



vg_assert_equal \
    "RESTORE" \
    "$VG_LEARNING_RECOMMENDATION" \
    "Acceptable strategy should remain"
