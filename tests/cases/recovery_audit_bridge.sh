#!/system/bin/sh
#
# Project Vanguard
# Recovery Audit Bridge Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"



VG_AUDIT_FILE="$TEST_DIR/recovery_bridge_audit.log"



. "$CORE_DIR/recovery_audit_bridge.sh"



rm -f "$VG_AUDIT_FILE"



cat > "$VG_AUDIT_FILE" <<EOF
EVENT=QUARANTINE_ADD
MODULE=test_module
RESULT=SUCCESS
TIME=20260727120000
---
EVENT=RECOVERY_SUCCESS
MODULE=test_module
RESULT=SUCCESS
TIME=20260727120001
---
EVENT=RECOVERY_FAILED
MODULE=test_module
RESULT=FAILED
TIME=20260727120002
---
EOF



vg_recovery_audit_bridge \
    "$VG_AUDIT_FILE" \
    "test_module"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Audit bridge sync should succeed"



vg_assert_equal \
    "3" \
    "$VG_RECOVERY_AUDIT_EVENTS" \
    "Audit event count"



vg_assert_equal \
    "2" \
    "$VG_RECOVERY_AUDIT_SUCCESS" \
    "Audit success count"



vg_assert_equal \
    "1" \
    "$VG_RECOVERY_AUDIT_FAILURE" \
    "Audit failure count"
