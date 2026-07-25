#!/system/bin/sh
#
# Project Vanguard
# Context Test Cases
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/context.sh"

vg_parse_manifest "$MODULE_DIR/example/module.prop" >/dev/null 2>&1

vg_assert_equal \
    "example" \
    "$VG_CONTEXT_MODULE_ID" \
    "Module ID parsed correctly"

vg_assert_equal \
    "Example Module" \
    "$VG_CONTEXT_MODULE_NAME" \
    "Module name parsed correctly"
