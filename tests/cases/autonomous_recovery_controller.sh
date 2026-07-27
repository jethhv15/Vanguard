#!/system/bin/sh
#
# Project Vanguard
# Autonomous Recovery Controller Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"

. "$CORE_DIR/autonomous_recovery_controller.sh"



#
# Healthy
#

vg_recovery_controller_evaluate \
    0 \
    healthy \
    0


vg_assert_equal \
    "NONE" \
    "$VG_CONTROLLER_ACTION" \
    "Healthy should do nothing"



#
# Retry
#

vg_recovery_controller_evaluate \
    1 \
    healthy \
    0


vg_assert_equal \
    "RETRY" \
    "$VG_CONTROLLER_ACTION" \
    "Minor failure should retry"



#
# Restore
#

vg_recovery_controller_evaluate \
    5 \
    healthy \
    0


vg_assert_equal \
    "RESTORE" \
    "$VG_CONTROLLER_ACTION" \
    "Repeated failure should restore"



#
# Loop protection
#

vg_recovery_controller_evaluate \
    1 \
    healthy \
    3


vg_assert_equal \
    "QUARANTINE" \
    "$VG_CONTROLLER_ACTION" \
    "Loop should quarantine"
