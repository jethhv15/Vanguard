#!/system/bin/sh
#
# Project Vanguard
# Recovery History Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_RECOVERY_HISTORY_FILE="${VG_RECOVERY_HISTORY_FILE:-/tmp/vanguard_recovery_history.log}"



#
# Prepare
#

vg_recovery_history_prepare()
{

    dir="$(dirname "$VG_RECOVERY_HISTORY_FILE")"


    [ -d "$dir" ] \
        || mkdir -p "$dir" 2>/dev/null


    return "$VG_SUCCESS"

}



#
# Record
#

vg_recovery_history_record()
{

    module="$1"
    action="$2"
    level="$3"
    result="$4"
    reason="$5"
    attempt="$6"


    vg_recovery_history_prepare \
        || return $?



    cat >> "$VG_RECOVERY_HISTORY_FILE" <<EOF
TIME=$(date '+%Y%m%d%H%M%S')
MODULE=$module
ACTION=$action
LEVEL=$level
RESULT=$result
REASON=$reason
ATTEMPT=$attempt
---
EOF


    return "$VG_SUCCESS"

}



#
# Last Entry
#

vg_recovery_history_last()
{

    [ -f "$VG_RECOVERY_HISTORY_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    awk '
    BEGIN { RS="---\n" }
    NF { last=$0 }
    END { print last }
    ' "$VG_RECOVERY_HISTORY_FILE"


    return "$VG_SUCCESS"

}



#
# Count
#

vg_recovery_history_count()
{

    [ -f "$VG_RECOVERY_HISTORY_FILE" ] \
        || {
            printf "0\n"
            return "$VG_SUCCESS"
        }


    grep -c "^TIME=" \
        "$VG_RECOVERY_HISTORY_FILE"


    return "$VG_SUCCESS"

}



#
# Clear
#

vg_recovery_history_clear()
{

    rm -f "$VG_RECOVERY_HISTORY_FILE" 2>/dev/null


    return "$VG_SUCCESS"

}
