#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_pipeline_runtime.sh"



vg_runtime_run



vg_assert_equal \
    "COMPLETE" \
    "$VG_RUNTIME_STATUS" \
    "Runtime should complete successfully"



vg_assert_equal \
    "LEARNING" \
    "$VG_RUNTIME_STAGE" \
    "Runtime should finish at learning stage"



vg_assert_equal \
    "COMPLETE" \
    "$(vg_runtime_status)" \
    "Status API should report complete"



vg_assert_equal \
    "LEARNING" \
    "$(vg_runtime_stage)" \
    "Stage API should report learning"
