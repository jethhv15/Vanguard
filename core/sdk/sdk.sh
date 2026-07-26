#!/system/bin/sh
#
# Project Vanguard
# SDK Loader
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
fi


. "$CORE_DIR/sdk/api.sh"
