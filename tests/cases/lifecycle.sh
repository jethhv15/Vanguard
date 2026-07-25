#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/lifecycle.sh"

vg_registry_reset || exit 1

vg_registry_add "example" || exit 1

vg_example_init() {
    return "$VG_SUCCESS"
}

vg_example_start() {
    return "$VG_SUCCESS"
}

vg_example_stop() {
    return "$VG_SUCCESS"
}

vg_lifecycle_init || exit 1
vg_lifecycle_start || exit 1
vg_lifecycle_stop || exit 1

exit 0
