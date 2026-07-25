#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/scanner.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_scan_modules >/dev/null 2>&1; echo $?)" \
    "Scanner should complete successfully"
