#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/sandbox.sh"



state="$(vg_sandbox_status)"

vg_assert_equal \
"disabled" \
"$state" \
"Sandbox initial state"



vg_sandbox_enable


state="$(vg_sandbox_status)"


vg_assert_equal \
"enabled" \
"$state" \
"Sandbox enabled"



vg_sandbox_disable


state="$(vg_sandbox_status)"


vg_assert_equal \
"disabled" \
"$state" \
"Sandbox disabled"
