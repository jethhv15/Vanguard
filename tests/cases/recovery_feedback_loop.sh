#!/system/bin/sh
#
# Project Vanguard
# Recovery Feedback Loop Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


. "$CORE_DIR/recovery_feedback_loop.sh"



#
# Matching result
#

vg_feedback_process \
    "RESTORE" \
    "SUCCESS" \
    "SUCCESS"



vg_assert_equal \
    "100" \
    "$VG_FEEDBACK_SCORE" \
    "Matching result should score perfect"



vg_assert_equal \
    "CONFIRMED" \
    "$VG_FEEDBACK_LEARNING" \
    "Successful result should confirm learning"



#
# Different result
#

vg_feedback_process \
    "RETRY" \
    "SUCCESS" \
    "FAILED"



vg_assert_equal \
    "50" \
    "$VG_FEEDBACK_SCORE" \
    "Different result should require adjustment"



vg_assert_equal \
    "ADJUST_REQUIRED" \
    "$VG_FEEDBACK_LEARNING" \
    "Failure should trigger adjustment"
