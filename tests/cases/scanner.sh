#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/scanner.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_scan_modules >/dev/null 2>&1; echo $?)" \
    "Scanner should complete successfully"
