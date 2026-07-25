#!/system/bin/sh
#
# Project Vanguard
# Lifecycle Failure Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/lifecycle.sh"


vg_registry_reset


#
# Load example module
#

vg_load_module "modules/example" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Example module loaded for rollback test"

vg_registry_add \
    "example" \
    "modules/example"


#
# Load failing module
#

vg_load_module "tests/fixtures/failing" >/dev/null 2>&1
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Failing module loaded for rollback test"

vg_registry_add \
    "failing" \
    "tests/fixtures/failing"


#
# Init
#

vg_lifecycle_init
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Lifecycle init completed before failure"


#
# Start should fail
#

vg_lifecycle_start
rc=$?

vg_assert_true \
    "[ \"$rc\" -ne \"$VG_SUCCESS\" ]" \
    "Lifecycle start should fail when module fails"
