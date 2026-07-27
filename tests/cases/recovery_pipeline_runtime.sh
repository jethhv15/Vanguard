#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_pipeline_runtime.sh"

vg_assert_equal \
    "READY" \
    "$VG_RUNTIME_STATUS" \
    "Runtime should start ready"

vg_runtime_run

vg_assert_equal \
    "COMPLETE" \
    "$VG_RUNTIME_STATUS" \
    "Runtime should complete"

vg_assert_equal \
    "INTEGRATION" \
    "$VG_RUNTIME_STAGE" \
    "Runtime should finish at integration stage"
