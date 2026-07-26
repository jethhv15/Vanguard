#!/system/bin/sh
#
# Project Vanguard
# Executor Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/executor.sh"



vg_registry_reset



vg_load_module \
"modules/example" >/dev/null 2>&1


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Executor module loaded"



vg_registry_add \
"example" \
"modules/example"



vg_executor_start


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Executor start completed"



state="$(vg_executor_status)"


vg_assert_equal \
"running" \
"$state" \
"Executor state should be running"



vg_executor_stop


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Executor stop completed"



state="$(vg_executor_status)"


vg_assert_equal \
"stopped" \
"$state" \
"Executor state should be stopped"
