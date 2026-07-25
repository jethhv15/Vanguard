#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/registry.sh"

vg_registry_reset

vg_registry_add "example"

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(test "$VG_LOADED_MODULE_COUNT" -eq 1; echo $?)" \
    "Registry should store module identifiers"
