#!/system/bin/sh
#
# Project Vanguard
# Module Quarantine Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

if [ -z "${VG_QUARANTINE_FILE:-}" ]; then
    VG_QUARANTINE_FILE="/tmp/vanguard_quarantine.db"
fi


VG_QUARANTINE_MODULE=""
VG_QUARANTINE_REASON=""
VG_QUARANTINE_STATUS=""



#
# Prepare
#

vg_quarantine_prepare()
{

    dir="$(dirname "$VG_QUARANTINE_FILE")"


    [ -d "$dir" ] \
        || mkdir -p "$dir" 2>/dev/null


    [ -f "$VG_QUARANTINE_FILE" ] \
        || touch "$VG_QUARANTINE_FILE"


    return "$VG_SUCCESS"

}



#
# Add Module
#

vg_quarantine_add()
{

    module="$1"
    reason="$2"


    vg_quarantine_prepare \
        || return $?



    if vg_quarantine_check "$module" >/dev/null 2>&1
    then

        return "$VG_ERR_GENERAL"

    fi



    cat >> "$VG_QUARANTINE_FILE" <<EOF
MODULE=$module
TIME=$(date '+%Y%m%d%H%M%S')
REASON=$reason
STATUS=QUARANTINED
---
EOF


    return "$VG_SUCCESS"

}



#
# Check Module
#

vg_quarantine_check()
{

    module="$1"


    [ -f "$VG_QUARANTINE_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    grep -Fqx \
        "MODULE=$module" \
        "$VG_QUARANTINE_FILE"


    rc=$?


    if [ "$rc" -eq 0 ]
    then

        return "$VG_SUCCESS"

    fi



    return "$VG_ERR_NOT_FOUND"

}



#
# Remove Module
#

vg_quarantine_remove()
{

    module="$1"


    [ -f "$VG_QUARANTINE_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    tmp="${VG_QUARANTINE_FILE}.tmp"



    awk -v target="MODULE=$module" '
    BEGIN {
        RS="---\n"
        ORS="---\n"
    }

    index($0,target) == 1 {
        next
    }

    {
        print
    }

    ' "$VG_QUARANTINE_FILE" > "$tmp"



    mv "$tmp" "$VG_QUARANTINE_FILE"



    return "$VG_SUCCESS"

}



#
# List
#

vg_quarantine_list()
{

    [ -f "$VG_QUARANTINE_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    grep "^MODULE=" \
        "$VG_QUARANTINE_FILE"



    return "$VG_SUCCESS"

}
