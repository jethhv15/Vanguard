#!/system/bin/sh
#
# Project Vanguard
# Recovery Verification Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_verifier.sh"



#
# Success verify
#

vg_recovery_verify_module \
    "test_module" \
    "active"



vg_assert_equal \
    "PASS" \
    "$VG_VERIFY_RESULT" \
    "Active module should verify"



#
# Failed verify
#

vg_recovery_verify_module \
    "test_module" \
    "failed"



vg_assert_equal \
    "FAIL" \
    "$VG_VERIFY_RESULT" \
    "Failed module should reject"



#
# Runtime verify
#

vg_recovery_verify_runtime \
    "healthy"



vg_assert_equal \
    "PASS" \
    "$VG_VERIFY_RESULT" \
    "Healthy runtime should pass"



#
# Rollback trigger
#

vg_recovery_verify_module \
    "test_module" \
    "failed"



vg_recovery_verify_rollback



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Failed recovery should request rollback"
