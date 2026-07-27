#!/system/bin/sh
#
# Project Vanguard
# Recovery Rules Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_rules.sh"



vg_recovery_rules_reset


vg_assert_equal \
    "3" \
    "$(vg_recovery_rules_retry_limit safe)" \
    "Safe retry limit"



vg_assert_equal \
    "2" \
    "$(vg_recovery_rules_retry_limit warning)" \
    "Warning retry limit"



vg_assert_equal \
    "0" \
    "$(vg_recovery_rules_retry_limit critical)" \
    "Critical retry limit"



vg_recovery_rules_resolve safe

vg_assert_equal \
    "RETRY_MODULE" \
    "$VG_RECOVERY_RULE_ACTION" \
    "Safe should retry"



vg_recovery_rules_resolve critical

vg_assert_equal \
    "RESTORE_SNAPSHOT" \
    "$VG_RECOVERY_RULE_ACTION" \
    "Critical should restore snapshot"
