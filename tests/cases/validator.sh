#!/system/bin/sh
#
# Project Vanguard
# Validator Test Cases
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/detect.sh"
. "$CORE_DIR/validator.sh"

vg_detect_device >/dev/null 2>&1

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_validate_environment >/dev/null 2>&1; echo $?)" \
    "vg_validate_environment accepts a valid environment"
