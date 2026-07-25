#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/context.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/dispatcher.sh"

vg_example_start() {
    return "$VG_SUCCESS"
}

vg_dispatch_module "modules/example" start

exit $?
