#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/sdk/sdk.sh"

vg_register_hook() {
    return 0
}

vg_hook_register "boot" "module_boot" || exit 1

exit 0
