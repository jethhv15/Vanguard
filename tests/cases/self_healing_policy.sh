#!/system/bin/sh
#
# Project Vanguard
# Self Healing Policy Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/self_healing_policy.sh"



#
# Retry case
#

vg_self_heal_decide 1 false


vg_assert_equal \
    "RETRY" \
    "$VG_HEAL_ACTION" \
    "One failure should retry"



#
# Restore case
#

vg_self_heal_decide 3 false


vg_assert_equal \
    "RESTORE" \
    "$VG_HEAL_ACTION" \
    "Three failures should restore"



#
# Quarantine case
#

vg_self_heal_decide 5 false


vg_assert_equal \
    "QUARANTINE" \
    "$VG_HEAL_ACTION" \
    "Five failures should quarantine"



#
# Critical case
#

vg_self_heal_decide 1 true


vg_assert_equal \
    "QUARANTINE" \
    "$VG_HEAL_ACTION" \
    "Critical failure should quarantine"
