#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/lifecycle.sh"

vg_registry_reset || exit 1

vg_load_module "modules/example" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Example module loaded successfully"

vg_registry_add "example" "modules/example" || exit 1

vg_lifecycle_init
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Lifecycle init completed successfully"

vg_lifecycle_start
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Lifecycle start completed successfully"

vg_lifecycle_stop
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Lifecycle stop completed successfully"
