#!/system/bin/sh
#
# Project Vanguard
# Recovery Intelligence Coordinator Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


. "$CORE_DIR/recovery_transaction_manager.sh"
. "$CORE_DIR/recovery_state_machine.sh"
. "$CORE_DIR/recovery_knowledge_base.sh"
. "$CORE_DIR/recovery_knowledge_integrator.sh"
. "$CORE_DIR/recovery_decision_engine.sh"
. "$CORE_DIR/recovery_intelligence_coordinator.sh"



VG_KB_FILE="$TEST_DIR/coordinator_kb.db"


rm -f "$VG_KB_FILE"



#
# Prepare knowledge
#

vg_recovery_kb_store \
    "module_crash" \
    "RESTORE" \
    95



#
# Coordinate recovery
#

vg_recovery_coordinate \
    "module_crash" \
    "RETRY"



vg_assert_equal \
    "RESTORE" \
    "$VG_COORD_ACTION" \
    "Coordinator should use knowledge decision"



vg_assert_equal \
    "READY" \
    "$VG_COORD_RESULT" \
    "Coordinator should prepare plan"



vg_assert_equal \
    "PLANNING" \
    "$VG_COORD_STATE" \
    "Coordinator should enter planning state"
