#!/system/bin/sh
#
# Project Vanguard
# Policy Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/policy.sh"



vg_policy_reset



vg_policy_add \
"STATE_CORRUPTION" \
"CRITICAL" \
"true" \
"0"



rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Policy add completed"



severity="$(vg_policy_severity STATE_CORRUPTION)"

vg_assert_equal \
"CRITICAL" \
"$severity" \
"Critical severity returned"



protected="$(vg_policy_protected STATE_CORRUPTION)"

vg_assert_equal \
"true" \
"$protected" \
"Protected flag returned"



retention="$(vg_policy_retention STATE_CORRUPTION)"

vg_assert_equal \
"0" \
"$retention" \
"Retention returned"



default="$(vg_policy_severity UNKNOWN_EVENT)"

vg_assert_equal \
"INFO" \
"$default" \
"Default severity returned"
