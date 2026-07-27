#!/system/bin/sh
#
# Project Vanguard
# Recovery Knowledge Base Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_KB_FILE="$TEST_DIR/recovery_kb.db"


. "$CORE_DIR/recovery_knowledge_base.sh"



rm -f "$VG_KB_FILE"



#
# Store pattern
#

vg_recovery_kb_store \
    "module_crash" \
    "RESTORE" \
    90



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Knowledge store should succeed"



#
# Lookup
#

vg_recovery_kb_lookup \
    "module_crash"



vg_assert_equal \
    "RESTORE" \
    "$VG_KB_STRATEGY" \
    "Lookup should return strategy"



vg_assert_equal \
    "HIGH" \
    "$VG_KB_CONFIDENCE" \
    "High success should create confidence"



#
# Unknown pattern
#

vg_recovery_kb_lookup \
    "unknown_pattern"



vg_assert_equal \
    "$VG_ERR_NOT_FOUND" \
    "$?" \
    "Unknown pattern should fail"
