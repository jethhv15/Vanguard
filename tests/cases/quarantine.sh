#!/system/bin/sh
#
# Project Vanguard
# Quarantine Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/quarantine.sh"



VG_QUARANTINE_FILE="$TEST_DIR/quarantine.db"



rm -f "$VG_QUARANTINE_FILE"



#
# Add
#

vg_quarantine_add \
    "bad_module" \
    "low reliability"



vg_assert_equal \
    "0" \
    "$?" \
    "Quarantine add"



#
# Check
#

vg_quarantine_check \
    "bad_module"


vg_assert_equal \
    "0" \
    "$?" \
    "Quarantine check"



#
# List
#

result="$(vg_quarantine_list)"

echo "$result" | grep "bad_module" >/dev/null


vg_assert_equal \
    "0" \
    "$?" \
    "Quarantine list"



#
# Remove
#

vg_quarantine_remove \
    "bad_module"



vg_quarantine_check \
    "bad_module"


vg_assert_not_equal \
    "0" \
    "$?" \
    "Quarantine remove"
