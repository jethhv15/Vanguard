#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/module_validator.sh"

VG_MODULE_ID="example"
VG_MODULE_NAME="Example Module"
VG_MODULE_VERSION="1.0.0"
VG_MODULE_VERSION_CODE="1"
VG_MODULE_AUTHOR="Jethro Kaspar"
VG_MODULE_DESCRIPTION="Example"
VG_MODULE_API="1"
VG_MODULE_ENTRY="module.sh"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(vg_validate_module; echo $?)" \
    "Module validator should accept a valid manifest"
