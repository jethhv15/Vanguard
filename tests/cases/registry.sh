#!/system/bin/sh
#
# Project Vanguard
# Registry Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"


vg_registry_reset


vg_registry_add \
    "example" \
    "modules/example" \
    "performance,thermal"



vg_assert_return_code \
    "$VG_SUCCESS" \
    "$(test "$VG_LOADED_MODULE_COUNT" -eq 1; echo $?)" \
    "Registry should store module identifiers"



dependencies="$(vg_registry_get_dependencies example)"


vg_assert_equal \
    "performance,thermal" \
    "$dependencies" \
    "Registry should store module dependencies"



path="$(vg_registry_get_path example)"


vg_assert_equal \
    "modules/example" \
    "$path" \
    "Registry should return module path"
