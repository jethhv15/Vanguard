#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_pipeline.sh"

vg_assert_equal \
    "READY" \
    "$VG_PIPELINE_STATUS" \
    "Pipeline should start ready"

vg_pipeline_run

vg_assert_equal \
    "COMPLETE" \
    "$VG_PIPELINE_STATUS" \
    "Pipeline should complete"

vg_assert_equal \
    "KNOWLEDGE" \
    "$VG_PIPELINE_STAGE" \
    "Pipeline should finish at knowledge stage"
