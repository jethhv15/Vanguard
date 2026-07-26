#!/system/bin/sh
#
# Project Vanguard
# Engine State Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/engine.sh"



vg_config_load >/dev/null 2>&1
vg_runtime_boot >/dev/null 2>&1



state="$(vg_engine_status)"

vg_assert_equal \
"idle" \
"$state" \
"Engine should start idle"



vg_engine_start >/dev/null 2>&1

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Engine first start completed"



state="$(vg_engine_status)"

vg_assert_equal \
"${VG_ENGINE_READY}" \
"$state" \
"Engine should become ready"



vg_engine_start >/dev/null 2>&1

rc=$?

vg_assert_return_code \
"$VG_ERR_INVALID" \
"$rc" \
"Engine should reject duplicate start"



vg_engine_stop >/dev/null 2>&1

rc=$?

vg_assert_return_code \
"$VG_SUCCESS" \
"$rc" \
"Engine stop completed"



state="$(vg_engine_status)"

vg_assert_equal \
"${VG_ENGINE_IDLE}" \
"$state" \
"Engine should return to idle"
