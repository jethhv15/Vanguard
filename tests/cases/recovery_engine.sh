#!/system/bin/sh
#
# Project Vanguard
# Recovery Decision Engine Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_engine.sh"


#
# Module failure case
#

VG_DIAGNOSTIC_MODULE="example"

vg_recovery_decide

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Recovery decision completed"



vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_ACTION" \
    "Recovery should choose module retry"



vg_assert_equal \
    "example" \
    "$VG_RECOVERY_TARGET" \
    "Recovery target should match module"



#
# Runtime failure case
#

VG_DIAGNOSTIC_MODULE=""

VG_RUNTIME_VALIDATED="false"


vg_recovery_decide


vg_assert_equal \
    "REBOOT_ENGINE" \
    "$VG_RECOVERY_ACTION" \
    "Recovery should reboot invalid runtime"



#
# Healthy case
#

VG_RUNTIME_VALIDATED="true"

VG_HEALTH_STATUS="healthy"


vg_recovery_decide


vg_assert_equal \
    "NONE" \
    "$VG_RECOVERY_ACTION" \
    "Healthy system should require no recovery"
