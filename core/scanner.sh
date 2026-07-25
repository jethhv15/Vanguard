#!/system/bin/sh
#
# Project Vanguard
# Scanner
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

VG_SCANNED_MODULES=""

vg_scan_modules() {

    VG_SCANNED_MODULES=""

    [ -d "$VG_MODULES_DIR" ] || return "$VG_ERR_NOT_FOUND"

    for module in "$VG_MODULES_DIR"/*; do
        [ -d "$module" ] || continue

        if [ -z "$VG_SCANNED_MODULES" ]; then
            VG_SCANNED_MODULES="$module"
        else
            VG_SCANNED_MODULES="${VG_SCANNED_MODULES}
$module"
        fi
    done

    return "$VG_SUCCESS"
}
