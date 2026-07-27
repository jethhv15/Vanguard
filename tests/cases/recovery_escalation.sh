#!/system/bin/sh
#
# Project Vanguard
# Recovery Escalation Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_escalation.sh"



vg_recovery_escalation_reset


vg_assert_equal \
    "0" \
    "$VG_RECOVERY_ESCALATION_LEVEL" \
    "Initial escalation level"



vg_recovery_escalate \
    "module failure"


vg_assert_equal \
    "1" \
    "$VG_RECOVERY_ESCALATION_LEVEL" \
    "First escalation level"


vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_ESCALATION_ACTION" \
    "First escalation action"



vg_recovery_escalate \
    "retry failed"


vg_assert_equal \
    "2" \
    "$VG_RECOVERY_ESCALATION_LEVEL" \
    "Second escalation level"


vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_ESCALATION_ACTION" \
    "Second escalation action"



vg_recovery_escalate \
    "snapshot failed"


vg_assert_equal \
    "ENGINE_FAILED" \
    "$VG_RECOVERY_ESCALATION_ACTION" \
    "Final escalation action"
