#!/system/bin/sh
#
# Project Vanguard
# Recovery Execution Orchestrator Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


. "$CORE_DIR/recovery_transaction_manager.sh"
. "$CORE_DIR/recovery_execution_orchestrator.sh"



#
# Prepare
#

vg_recovery_execution_prepare \
    "RESTORE"



vg_assert_equal \
    "PREPARED" \
    "$VG_EXEC_STATE" \
    "Execution should prepare"



#
# Execute
#

vg_recovery_execution_run



vg_assert_equal \
    "EXECUTING" \
    "$VG_EXEC_STATE" \
    "Execution should start"



#
# Verify
#

vg_recovery_execution_verify



vg_assert_equal \
    "VERIFYING" \
    "$VG_EXEC_STATE" \
    "Execution should verify"



#
# Commit
#

vg_recovery_execution_commit



vg_assert_equal \
    "COMPLETED" \
    "$VG_EXEC_STATE" \
    "Execution should complete"
