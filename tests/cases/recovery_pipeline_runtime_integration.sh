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
. "$CORE_DIR/recovery_telemetry.sh"
. "$CORE_DIR/recovery_analytics_engine.sh"
. "$CORE_DIR/recovery_optimization_engine.sh"
. "$CORE_DIR/recovery_knowledge_base.sh"
. "$CORE_DIR/recovery_knowledge_integrator.sh"
. "$CORE_DIR/recovery_pipeline_runtime.sh"



rm -f "$VG_STRATEGY_FILE"
rm -f "$VG_TELEMETRY_FILE"
rm -f "$VG_KB_FILE"



vg_runtime_run



vg_assert_equal \
    "COMPLETE" \
    "$VG_RUNTIME_STATUS" \
    "Pipeline should complete"



vg_assert_equal \
    "INTEGRATION" \
    "$VG_RUNTIME_STAGE" \
    "Pipeline should reach final stage"



#
# Strategy
#

vg_assert_equal \
    "RESTORE" \
    "$VG_SELECTED_STRATEGY" \
    "Runtime should select highest ranked strategy"



vg_assert_equal \
    "95" \
    "$VG_STRATEGY_SCORE" \
    "Runtime should keep best strategy score"



#
# Telemetry
#

vg_assert_equal \
    "RECOVERY_PIPELINE" \
    "$VG_TELEMETRY_EVENT" \
    "Telemetry should record pipeline event"



vg_assert_equal \
    "RESTORE" \
    "$VG_TELEMETRY_ACTION" \
    "Telemetry should record selected strategy"



vg_assert_equal \
    "SUCCESS" \
    "$VG_TELEMETRY_RESULT" \
    "Telemetry should record successful recovery"



#
# Analytics
#

vg_assert_equal \
    "1" \
    "$VG_ANALYTICS_TOTAL" \
    "Analytics should count one recovery"



vg_assert_equal \
    "1" \
    "$VG_ANALYTICS_SUCCESS" \
    "Analytics should count one successful recovery"



vg_assert_equal \
    "0" \
    "$VG_ANALYTICS_FAILED" \
    "Analytics should report zero failures"



vg_assert_equal \
    "100" \
    "$VG_ANALYTICS_RATE" \
    "Analytics should report 100 percent success"



vg_assert_equal \
    "HIGH" \
    "$VG_ANALYTICS_SCORE" \
    "Analytics score should be HIGH"



vg_assert_equal \
    "RESTORE" \
    "$VG_ANALYTICS_BEST_ACTION" \
    "Analytics should detect best action"



#
# Optimization
#

vg_assert_equal \
    "RESTORE" \
    "$VG_OPT_ACTION" \
    "Optimizer should keep best action"



vg_assert_equal \
    "HIGH" \
    "$VG_OPT_SCORE" \
    "Optimizer score should be HIGH"



vg_assert_equal \
    "95" \
    "$VG_OPT_CONFIDENCE" \
    "Optimizer confidence should be 95"



vg_assert_equal \
    "high historical success" \
    "$VG_OPT_REASON" \
    "Optimizer should explain recommendation"



#
# Policy
#

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



#
# Feedback
#

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



#
# Knowledge Base
#

vg_assert_equal \
    "RECOVERY_PIPELINE" \
    "$VG_KB_PATTERN" \
    "Knowledge Base should store pipeline pattern"



vg_assert_equal \
    "RESTORE" \
    "$VG_KB_STRATEGY" \
    "Knowledge Base should store selected strategy"



vg_assert_equal \
    "100" \
    "$VG_KB_SUCCESS" \
    "Knowledge Base should store success rate"



vg_assert_equal \
    "HIGH" \
    "$VG_KB_CONFIDENCE" \
    "Knowledge Base confidence should be HIGH"



#
# Knowledge Integrator
#

vg_assert_equal \
    "RECOVERY_PIPELINE" \
    "$VG_INTEGRATOR_PATTERN" \
    "Integrator should keep recovery pattern"



vg_assert_equal \
    "RESTORE" \
    "$VG_INTEGRATOR_ACTION" \
    "Integrator should use learned strategy"



vg_assert_equal \
    "HIGH" \
    "$VG_INTEGRATOR_CONFIDENCE" \
    "Integrator confidence should be HIGH"



vg_assert_equal \
    "knowledge_base" \
    "$VG_INTEGRATOR_SOURCE" \
    "Integrator should use knowledge base"



vg_assert_equal \
    "decision matches knowledge" \
    "$VG_INTEGRATOR_REASON" \
    "Integrator should confirm matching decision"
