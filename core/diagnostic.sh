#!/system/bin/sh
#
# Project Vanguard
# Diagnostic Framework
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


VG_DIAG_STAGE=""
VG_DIAG_MODULE=""
VG_DIAG_REASON=""
VG_DIAG_RESULT="$VG_SUCCESS"



vg_diag_reset()
{

    VG_DIAG_STAGE=""
    VG_DIAG_MODULE=""
    VG_DIAG_REASON=""
    VG_DIAG_RESULT="$VG_SUCCESS"

    return "$VG_SUCCESS"

}



vg_diag_set()
{

    VG_DIAG_STAGE="$1"
    VG_DIAG_MODULE="$2"
    VG_DIAG_REASON="$3"
    VG_DIAG_RESULT="$4"


    return "$VG_SUCCESS"

}



vg_diag_print()
{

    printf '%s\n' \
"STAGE=$VG_DIAG_STAGE
MODULE=$VG_DIAG_MODULE
REASON=$VG_DIAG_REASON
RESULT=$VG_DIAG_RESULT"

    return "$VG_SUCCESS"

}
