#!/system/bin/sh
#
# Project Vanguard
# Resolver Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/resolver.sh"


vg_registry_reset


vg_registry_add \
    "thermal" \
    "modules/thermal" \
    ""


vg_registry_add \
    "performance" \
    "modules/performance" \
    "thermal"


vg_registry_add \
    "gaming" \
    "modules/gaming" \
    "performance"


vg_dependency_resolve gaming

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Resolver should resolve dependency chain"



vg_assert_equal \
    "thermal
performance
gaming" \
    "$VG_RESOLVE_ORDER" \
    "Resolver should return correct load order"
