#!/system/bin/sh
#
# Project Vanguard
# Discovery Manager Tests
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/discovery.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_discover >/dev/null 2>&1; echo $?)" \
    "vg_discover completes successfully"
