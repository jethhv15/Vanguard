#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/dispatcher.sh"

vg_registry_reset

vg_registry_add "example" "modules/example"

vg_load_module "modules/example" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module loaded successfully"

vg_dispatch_module "example" "start" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module dispatched successfully"
