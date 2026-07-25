#!/system/bin/sh
#
# Project Vanguard
# Example Module Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/loader.sh"

vg_load_module "modules/example" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Example module loaded successfully"
