#!/system/bin/sh

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
CORE_DIR="$(CDPATH= cd -- "$TEST_DIR/../core" && pwd)"

. "$CORE_DIR/engine.sh"

vg_engine_start >/dev/null 2>&1

test "$VG_LOADED_MODULE_COUNT" -gt 0
