#!/system/bin/sh
#
# Project Vanguard
# Atomic Engine Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/atomic.sh"



vg_atomic_reset


state="$(vg_atomic_status)"

vg_assert_equal \
"idle" \
"$state" \
"Atomic initial state"



vg_atomic_begin

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Atomic begin completed"



state="$(vg_atomic_status)"

vg_assert_equal \
"running" \
"$state" \
"Atomic running state"



vg_atomic_commit

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Atomic commit completed"



state="$(vg_atomic_status)"

vg_assert_equal \
"committed" \
"$state" \
"Atomic committed state"



vg_atomic_reset


vg_atomic_begin >/dev/null


vg_atomic_fail

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Atomic rollback completed"



state="$(vg_atomic_status)"

vg_assert_equal \
"rolledback" \
"$state" \
"Atomic rollback state"
