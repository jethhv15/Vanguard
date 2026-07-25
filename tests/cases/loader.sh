#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/loader.sh"

vg_assert_return_code \
    "$VG_ERR_NOT_FOUND" \
    "$(vg_load_module "/does/not/exist" >/dev/null 2>&1; echo $?)" \
    "Loader should fail when module directory does not exist"
