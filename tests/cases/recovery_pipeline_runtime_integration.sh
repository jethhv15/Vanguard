#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime Integration Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"

. "$CORE_DIR/recovery_strategy_manager.sh"
. "$CORE_DIR/recovery_policy_adaptation.sh"
. "$CORE_DIR/recovery_feedback_loop.sh"
. "$CORE_DIR/recovery_pipeline_runtime.sh"



rm -f "$VG_STRATEGY_FILE"



vg_runtime_run



vg_assert_equal \
    "COMPLETE" \
    "$VG_RUNTIME_STATUS" \
    "Pipeline should complete"



vg_assert_equal \
    "KNOWLEDGE" \
    "$VG_RUNTIME_STAGE" \
    "Pipeline should reach final stage"



vg_assert_equal \
    "RESTORE" \
    "$VG_SELECTED_STRATEGY" \
    "Runtime should select highest ranked strategy"



vg_assert_equal \
    "95" \
    "$VG_STRATEGY_SCORE" \
    "Runtime should keep best strategy score"



vg_assert_equal \
    "RESTORE" \
    "$VG_POLICY_ACTION" \
    "Policy should adapt selected strategy"



vg_assert_equal \
    "VERY_HIGH" \
    "$VG_POLICY_PRIORITY" \
    "Policy priority should be VERY_HIGH"



vg_assert_equal \
    "95" \
    "$VG_POLICY_CONFIDENCE" \
    "Policy confidence should be preserved"



vg_assert_equal \
    "RESTORE" \
    "$VG_FEEDBACK_ACTION" \
    "Feedback should evaluate selected strategy"



vg_assert_equal \
    "100" \
    "$VG_FEEDBACK_SCORE" \
    "Feedback score should be perfect"



vg_assert_equal \
    "CONFIRMED" \
    "$VG_FEEDBACK_LEARNING" \
    "Feedback learning should be confirmed"
