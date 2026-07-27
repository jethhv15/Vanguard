#!/system/bin/sh
#
# Project Vanguard
# Recovery Decision Engine Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_KB_FILE="$TEST_DIR/decision_kb.db"


. "$CORE_DIR/recovery_knowledge_base.sh"
. "$CORE_DIR/recovery_knowledge_integrator.sh"
. "$CORE_DIR/recovery_decision_engine.sh"



rm -f "$VG_KB_FILE"



#
# Store known success
#

vg_recovery_kb_store \
    "module_crash" \
    "RESTORE" \
    95



#
# Decision from knowledge
#

vg_recovery_decide \
    "module_crash" \
    "RETRY"



vg_assert_equal \
    "RESTORE" \
    "$VG_DECISION_ACTION" \
    "Knowledge should influence decision"



vg_assert_equal \
    "HIGH" \
    "$VG_DECISION_PRIORITY" \
    "Restore should have high priority"



#
# Critical override
#

vg_recovery_decide \
    "network_failure" \
    "RETRY" \
    "critical"



vg_assert_equal \
    "QUARANTINE" \
    "$VG_DECISION_ACTION" \
    "Critical should quarantine"
