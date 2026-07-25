#!/system/bin/sh
#
# Project Vanguard
# SDK Property Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/sdk/sdk.sh"

VG_CURRENT_MODULE_ID="example"
VG_CURRENT_MODULE_NAME="Example Module"
VG_CURRENT_MODULE_VERSION="1.0.0"
VG_CURRENT_MODULE_AUTHOR="Project Vanguard"
VG_CURRENT_MODULE_DESCRIPTION="Example module"
VG_CURRENT_MODULE_API="1"
VG_CURRENT_MODULE_PATH="/modules/example"

vg_assert_equal \
    "example" \
    "$(vg_property_get id)" \
    "SDK property id returned correctly"

vg_assert_equal \
    "Example Module" \
    "$(vg_property_get name)" \
    "SDK property name returned correctly"

vg_assert_equal \
    "1.0.0" \
    "$(vg_property_get version)" \
    "SDK property version returned correctly"

vg_assert_equal \
    "Project Vanguard" \
    "$(vg_property_get author)" \
    "SDK property author returned correctly"

vg_assert_equal \
    "Example module" \
    "$(vg_property_get description)" \
    "SDK property description returned correctly"

vg_assert_equal \
    "1" \
    "$(vg_property_get api)" \
    "SDK property api returned correctly"

vg_assert_equal \
    "/modules/example" \
    "$(vg_property_get path)" \
    "SDK property path returned correctly"
