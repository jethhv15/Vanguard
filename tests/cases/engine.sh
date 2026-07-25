#!/system/bin/sh

. "$CORE_DIR/engine.sh"

vg_engine_start >/dev/null 2>&1

test "$VG_LOADED_MODULE_COUNT" -gt 0
