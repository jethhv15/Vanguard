#!/system/bin/sh
#
# Project Vanguard
# SDK Framework Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/sdk/sdk.sh"

version="$(vg_framework_version)"
api="$(vg_framework_api)"

vg_assert_equal \
    "$VG_VERSION" \
    "$version" \
    "Framework version returned correctly"

vg_assert_equal \
    "$VG_API_VERSION" \
    "$api" \
    "Framework API returned correctly"

vg_require_api "$VG_API_VERSION"
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Framework API requirement accepted"
