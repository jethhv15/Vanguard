#!/system/bin/sh
#
# Project Vanguard
# SDK Hook Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/sdk/sdk.sh"

vg_register_hook() {

    return "$VG_SUCCESS"
}

vg_hook_register "boot" "module_boot"
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "SDK hook registration completed successfully"
