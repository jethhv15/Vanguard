#!/system/bin/sh
#
# Project Vanguard
# Recovery Optimization Engine Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


. "$CORE_DIR/recovery_optimization_engine.sh"



#
# High success
#

vg_recovery_optimize \
    "RESTORE" \
    95



vg_assert_equal \
    "HIGH" \
    "$VG_OPT_SCORE" \
    "High success should score high"



vg_assert_equal \
    "95" \
    "$VG_OPT_CONFIDENCE" \
    "Confidence should increase"



#
# Low success
#

vg_recovery_optimize \
    "RESTORE" \
    20



vg_recovery_optimizer_recommend



vg_assert_equal \
    "ROLLBACK" \
    "$VG_OPT_ACTION" \
    "Low success should recommend rollback"
