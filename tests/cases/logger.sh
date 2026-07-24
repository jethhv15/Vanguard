#!/system/bin/sh
#
# Project Vanguard
# Logger Test Cases
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/logger.sh"

vg_assert_return_code \
    "$VG_ERR_GENERAL" \
    "$(vg_log INFO >/dev/null 2>&1; echo $?)" \
    "vg_log returns error when message is missing"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_info "Hello Vanguard" >/dev/null 2>&1; echo $?)" \
    "vg_info accepts valid message"
