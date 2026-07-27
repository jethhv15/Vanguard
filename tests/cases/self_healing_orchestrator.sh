#!/system/bin/sh
#
# Project Vanguard
# Self Healing Orchestrator Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"

. "$CORE_DIR/self_healing_policy.sh"
. "$CORE_DIR/self_healing_executor.sh"
. "$CORE_DIR/self_healing_orchestrator.sh"



#
# Retry pipeline
#

vg_self_heal_orchestrate \
    "test_module" \
    1 \
    false



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Retry orchestration should succeed"



vg_assert_equal \
    "RETRY" \
    "$VG_ORCH_DECISION" \
    "Retry decision"



vg_assert_equal \
    "SUCCESS" \
    "$VG_ORCH_RESULT" \
    "Retry result"



#
# Restore pipeline
#

vg_self_heal_orchestrate \
    "test_module" \
    3 \
    false



vg_assert_equal \
    "RESTORE" \
    "$VG_ORCH_DECISION" \
    "Restore decision"



#
# Critical pipeline
#

vg_self_heal_orchestrate \
    "test_module" \
    1 \
    true



vg_assert_equal \
    "QUARANTINE" \
    "$VG_ORCH_DECISION" \
    "Critical decision"
