#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/loader.sh"


vg_load_module "modules/example"

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Trusted module loaded"
