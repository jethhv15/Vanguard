#!/system/bin/sh
#
# Project Vanguard
# Quarantine Audit Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_QUARANTINE_AUDIT_FILE="$TEST_DIR/quarantine_audit.log"


. "$CORE_DIR/quarantine_audit.sh"



rm -f "$VG_QUARANTINE_AUDIT_FILE"



#
# Write event
#

vg_quarantine_audit_write \
    "QUARANTINE_ADD" \
    "test_module" \
    "low reliability" \
    "SUCCESS"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Audit write should succeed"



#
# Find event
#

vg_quarantine_audit_find \
    "QUARANTINE_ADD"



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Audit event should exist"



#
# List
#

result="$(vg_quarantine_audit_list)"


echo "$result" | grep "test_module" >/dev/null



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Audit list should contain module"
