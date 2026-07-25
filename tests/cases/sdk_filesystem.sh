#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/sdk/sdk.sh"

vg_fs_exists "/" || exit 1
vg_fs_is_dir "/" || exit 1
vg_fs_is_file "/system/build.prop" || exit 1

content="$(vg_fs_read "/system/build.prop")"

[ -n "$content" ] || exit 1

exit 0
