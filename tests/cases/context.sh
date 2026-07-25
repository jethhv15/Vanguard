#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/parser.sh"
. "$CORE_DIR/context.sh"

vg_parse_manifest "modules/example/module.prop" || exit 1

vg_context_set "modules/example" || exit 1

[ "$VG_CURRENT_MODULE_ID" = "example" ] || exit 1
[ "$VG_CURRENT_MODULE_PATH" = "modules/example" ] || exit 1

vg_context_clear || exit 1

[ -z "$VG_CURRENT_MODULE_ID" ] || exit 1

exit 0
