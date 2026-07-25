#!/system/bin/sh
#
# Project Vanguard
# Bootstrap Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/bootstrap.sh"

VG_CONFIG_FILE="$CONFIG_DIR/default.conf"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_bootstrap >/dev/null 2>&1; echo $?)" \
    "vg_bootstrap completes successfully with a valid configuration"
