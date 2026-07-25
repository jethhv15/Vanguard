#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/sdk/sdk.sh"

VG_CURRENT_MODULE_ID="example"
VG_CURRENT_MODULE_NAME="Example Module"
VG_CURRENT_MODULE_VERSION="1.0.0"
VG_CURRENT_MODULE_AUTHOR="Project Vanguard"
VG_CURRENT_MODULE_DESCRIPTION="Example module"
VG_CURRENT_MODULE_API="1"
VG_CURRENT_MODULE_PATH="/modules/example"

[ "$(vg_property_get id)" = "example" ] || exit 1
[ "$(vg_property_get name)" = "Example Module" ] || exit 1
[ "$(vg_property_get version)" = "1.0.0" ] || exit 1
[ "$(vg_property_get author)" = "Project Vanguard" ] || exit 1
[ "$(vg_property_get description)" = "Example module" ] || exit 1
[ "$(vg_property_get api)" = "1" ] || exit 1
[ "$(vg_property_get path)" = "/modules/example" ] || exit 1

exit 0
