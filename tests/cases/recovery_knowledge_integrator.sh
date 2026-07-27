#!/system/bin/sh
#
# Project Vanguard
# Recovery Knowledge Integrator Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_KB_FILE="$TEST_DIR/integrator_kb.db"


. "$CORE_DIR/recovery_knowledge_base.sh"
. "$CORE_DIR/recovery_knowledge_integrator.sh"



rm -f "$VG_KB_FILE"



#
# Store experience
#

vg_recovery_kb_store \
    "module_crash" \
    "RESTORE" \
    95



#
# Integrate known pattern
#

vg_recovery_integrate_knowledge \
    "module_crash" \
    "RETRY"



vg_assert_equal \
    "RESTORE" \
    "$VG_INTEGRATOR_ACTION" \
    "Knowledge should override weak policy"



vg_assert_equal \
    "HIGH" \
    "$VG_INTEGRATOR_CONFIDENCE" \
    "Knowledge confidence should remain"



#
# Unknown pattern
#

vg_recovery_integrate_knowledge \
    "network_issue" \
    "RETRY"



vg_assert_equal \
    "RETRY" \
    "$VG_INTEGRATOR_ACTION" \
    "Unknown pattern should use fallback"
