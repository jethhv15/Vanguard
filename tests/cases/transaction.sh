#!/system/bin/sh
#
# Project Vanguard
# Transaction Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/transaction.sh"



vg_transaction_reset


state="$(vg_transaction_status)"


vg_assert_equal \
"idle" \
"$state" \
"Transaction initial state"



vg_transaction_begin

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Transaction begin completed"



state="$(vg_transaction_status)"

vg_assert_equal \
"running" \
"$state" \
"Transaction running state"



vg_transaction_commit

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Transaction commit completed"



state="$(vg_transaction_status)"


vg_assert_equal \
"committed" \
"$state" \
"Transaction committed state"



vg_transaction_reset


vg_transaction_begin >/dev/null


vg_transaction_rollback

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Transaction rollback completed"



state="$(vg_transaction_status)"


vg_assert_equal \
"rolledback" \
"$state" \
"Transaction rollback state"
