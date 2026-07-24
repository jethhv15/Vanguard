#!/system/bin/sh
#
# Project Vanguard
# Framework Tests
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/framework.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_framework_start >/dev/null 2>&1; echo $?)" \
    "Framework should start successfully"
