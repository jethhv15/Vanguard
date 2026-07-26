#!/system/bin/sh
#
# Project Vanguard
# Dependency Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/dependency.sh"


vg_registry_reset


#
# Module without dependency
#

vg_registry_add \
    "example" \
    "modules/example" \
    ""


rc="$(vg_dependency_check example; echo $?)"


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Dependency check accepts module without dependency"



#
# Existing dependency
#

vg_registry_reset


vg_registry_add \
    "performance" \
    "modules/performance" \
    ""


vg_registry_add \
    "gaming" \
    "modules/gaming" \
    "performance"


rc="$(vg_dependency_check gaming; echo $?)"


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Dependency check accepts existing dependencies"



#
# Missing dependency
#

vg_registry_reset


vg_registry_add \
    "gaming" \
    "modules/gaming" \
    "missing"


rc="$(vg_dependency_check gaming; echo $?)"


vg_assert_return_code \
    "$VG_ERR_DEPENDENCY" \
    "$rc" \
    "Dependency check rejects missing dependencies"
