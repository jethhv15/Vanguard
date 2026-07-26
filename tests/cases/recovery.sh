#!/system/bin/sh
#
# Project Vanguard
# Recovery Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/recovery.sh"



vg_audit_clear



vg_audit_write \
"TEST_EVENT" \
"example" \
"" \
"" \
"$VG_SUCCESS"


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Recovery audit source created"



vg_recovery_snapshot


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit snapshot created"



vg_recovery_check


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit integrity check passed"



vg_recovery_restore


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Audit restore completed"
