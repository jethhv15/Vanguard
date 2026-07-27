#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime Integration Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"

. "$CORE_DIR/recovery_strategy_manager.sh"
. "$CORE_DIR/recovery_pipeline_runtime.sh"



#
# Clean previous strategy database
#

rm -f "$VG_STRATEGY_FILE"



#
# Execute runtime
#

vg_runtime_run



#
# Runtime should complete
#

vg_assert_equal \
    "COMPLETE" \
    "$VG_RUNTIME_STATUS" \
    "Pipeline should complete"



#
# Runtime should finish at KNOWLEDGE stage
#

vg_assert_equal \
    "KNOWLEDGE" \
    "$VG_RUNTIME_STAGE" \
    "Pipeline should reach final stage"



#
# Strategy manager should choose RESTORE
#

vg_assert_equal \
    "RESTORE" \
    "$VG_SELECTED_STRATEGY" \
    "Runtime should select highest ranked strategy"



#
# Strategy score should be preserved
#

vg_assert_equal \
    "95" \
    "$VG_STRATEGY_SCORE" \
    "Runtime should keep best strategy score"
