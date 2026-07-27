#!/system/bin/sh
#
# Project Vanguard
# Recovery Transaction Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_transaction.sh"



#
# Initial
#

vg_assert_equal \
    "idle" \
    "$(vg_recovery_tx_status)" \
    "Recovery transaction initial state"



#
# Begin
#

vg_recovery_tx_begin \
    "RETRY_MODULE" \
    "example"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Recovery transaction begin"



vg_assert_equal \
    "running" \
    "$(vg_recovery_tx_status)" \
    "Recovery transaction running state"



#
# Commit
#

vg_recovery_tx_commit


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Recovery transaction commit"



vg_assert_equal \
    "committed" \
    "$(vg_recovery_tx_status)" \
    "Recovery transaction committed state"



#
# Rollback path
#

vg_recovery_tx_reset


vg_recovery_tx_begin \
    "RETRY_MODULE" \
    "example"


vg_recovery_tx_rollback


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Recovery transaction rollback"



vg_assert_equal \
    "rolled_back" \
    "$(vg_recovery_tx_status)" \
    "Recovery transaction rollback state"
