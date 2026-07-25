#!/system/bin/sh
#
# Project Vanguard
# Scanner Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/scanner.sh"

vg_config_load >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Configuration loaded before scanner test"


vg_scan_modules >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Scanner should complete successfully"
