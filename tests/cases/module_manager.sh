#!/system/bin/sh
#
# Project Vanguard
# Module Manager Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/module_manager.sh"



vg_registry_reset



vg_load_module \
"modules/example" >/dev/null 2>&1


rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Module manager module loaded"



vg_registry_add \
"example" \
"modules/example"



exists="$(vg_module_exists example)"

vg_assert_return_code \
"$VG_SUCCESS" \
"$?" \
"Module exists"



list="$(vg_module_list)"


vg_assert_equal \
"example" \
"$list" \
"Module list returned"



vg_module_start example

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Module start completed"



vg_module_stop example

rc=$?


vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Module stop completed"
