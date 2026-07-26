#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/planner.sh"


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



vg_planner_build gaming

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Planner should build startup plan"



vg_assert_equal \
    "thermal
performance
gaming" \
    "$VG_STARTUP_PLAN" \
    "Planner should preserve dependency startup order"
