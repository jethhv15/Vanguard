#!/system/bin/sh
#
# Project Vanguard
# Controller Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/controller.sh"



vg_registry_reset



vg_load_module \
"modules/example" >/dev/null 2>&1


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Controller module loaded"



vg_registry_add \
"example" \
"modules/example"



vg_controller_start

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Controller start completed"



state="$(vg_controller_status)"


vg_assert_equal \
"running" \
"$state" \
"Controller state should be running"



vg_controller_stop

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Controller stop completed"



state="$(vg_controller_status)"


vg_assert_equal \
"stopped" \
"$state" \
"Controller state should be stopped"
