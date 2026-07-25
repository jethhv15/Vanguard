#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/sdk/sdk.sh"

TMP_FILE="/tmp/vanguard_sdk_test"

vg_fs_write "$TMP_FILE" "hello"

vg_fs_exists "$TMP_FILE" || exit 1
vg_fs_is_file "$TMP_FILE" || exit 1

content="$(vg_fs_read "$TMP_FILE")"

[ "$content" = "hello" ] || exit 1

rm -f "$TMP_FILE"

exit 0
