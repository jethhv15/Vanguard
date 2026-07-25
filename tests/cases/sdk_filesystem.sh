#!/system/bin/sh

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/sdk/sdk.sh"

if [ -n "${TMPDIR:-}" ]; then
    TMP_FILE="$TMPDIR/vanguard_sdk_test"
else
    TMP_FILE="./vanguard_sdk_test"
fi

vg_fs_write "$TMP_FILE" "hello"
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "SDK filesystem write completed successfully"

vg_fs_exists "$TMP_FILE"
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "SDK filesystem file exists"

vg_fs_is_file "$TMP_FILE"
rc=$?

vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "SDK filesystem detects file"

content="$(vg_fs_read "$TMP_FILE")"

vg_assert_equal \
    "hello" \
    "$content" \
    "SDK filesystem reads content"

rm -f "$TMP_FILE"
