#!/system/bin/sh
#
# Project Vanguard
# SDK State API
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
fi

. "$CORE_DIR/state.sh"
