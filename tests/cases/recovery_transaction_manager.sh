#!/system/bin/sh
#
# Project Vanguard
# Recovery Transaction Manager Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_transaction_manager.sh"



#
# Begin transaction
#

vg_recovery_transaction_begin \
    "RESTORE"



vg_assert_equal \
    "ACTIVE" \
    "$VG_TRANSACTION_STATE" \
    "Transaction should start"



#
# Commit
#

vg_recovery_transaction_commit



vg_assert_equal \
    "COMMITTED" \
    "$VG_TRANSACTION_STATE" \
    "Transaction should commit"



vg_recovery_transaction_verify



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Committed transaction should verify"



#
# Rollback
#

vg_recovery_transaction_begin \
    "RESTORE"



vg_recovery_transaction_rollback



vg_assert_equal \
    "ROLLED_BACK" \
    "$VG_TRANSACTION_STATE" \
    "Transaction should rollback"
