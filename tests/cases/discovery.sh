#!/system/bin/sh
#
# Project Vanguard
# Discovery Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/discovery.sh"

vg_discover_modules >/dev/null 2>&1

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$?" \
    "Module discovery completed successfully"
