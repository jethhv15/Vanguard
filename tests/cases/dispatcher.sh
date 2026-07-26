#!/system/bin/sh
#
# Project Vanguard
# Dispatcher Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/dispatcher.sh"


vg_registry_reset


vg_registry_add \
    "example" \
    "modules/example"


vg_load_module "modules/example" >/dev/null 2>&1
rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module loaded successfully"



vg_dispatch_module "example" "init" >/dev/null 2>&1
rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module init dispatched successfully"



vg_dispatch_module "example" "start" >/dev/null 2>&1
rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module start dispatched successfully"



vg_dispatch_module "example" "stop" >/dev/null 2>&1
rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Module stop dispatched successfully"



vg_dispatch_module "example" "invalid" >/dev/null 2>&1
rc=$?


vg_assert_return_code \
    "$VG_ERR_INVALID" \
    "$rc" \
    "Dispatcher rejects invalid action"
