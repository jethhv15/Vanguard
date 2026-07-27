#!/system/bin/sh
#
# Project Vanguard
# Recovery History Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_history.sh"



VG_RECOVERY_HISTORY_FILE="$TEST_DIR/recovery_history.log"



vg_recovery_history_clear



vg_recovery_history_record \
    "example" \
    "RETRY_MODULE" \
    "safe" \
    "SUCCESS" \
    "module failed" \
    "1"



vg_assert_equal \
    "1" \
    "$(vg_recovery_history_count)" \
    "History count should increase"



result="$(vg_recovery_history_last)"



echo "$result" | grep "MODULE=example" >/dev/null


vg_assert_equal \
    "0" \
    "$?" \
    "History should contain module"



vg_recovery_history_clear



vg_assert_equal \
    "0" \
    "$(vg_recovery_history_count)" \
    "History clear completed"
