#!/system/bin/sh
#
# Project Vanguard
# Quarantine Audit Integration
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_QUARANTINE_AUDIT_FILE="${VG_QUARANTINE_AUDIT_FILE:-/tmp/vanguard_quarantine_audit.log}"



#
# Prepare
#

vg_quarantine_audit_prepare()
{

    dir="$(dirname "$VG_QUARANTINE_AUDIT_FILE")"


    [ -d "$dir" ] \
        || mkdir -p "$dir" 2>/dev/null


    [ -f "$VG_QUARANTINE_AUDIT_FILE" ] \
        || touch "$VG_QUARANTINE_AUDIT_FILE"


    return "$VG_SUCCESS"

}



#
# Write Event
#

vg_quarantine_audit_write()
{

    event="$1"
    module="$2"
    reason="$3"
    result="$4"



    vg_quarantine_audit_prepare \
        || return $?



    cat >> "$VG_QUARANTINE_AUDIT_FILE" <<EOF
EVENT=$event
MODULE=$module
REASON=$reason
RESULT=$result
TIME=$(date '+%Y%m%d%H%M%S')
---
EOF


    return "$VG_SUCCESS"

}



#
# Find Event
#

vg_quarantine_audit_find()
{

    event="$1"


    [ -f "$VG_QUARANTINE_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    grep -q "^EVENT=$event$" \
        "$VG_QUARANTINE_AUDIT_FILE"



    return $?

}



#
# List
#

vg_quarantine_audit_list()
{

    [ -f "$VG_QUARANTINE_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    cat "$VG_QUARANTINE_AUDIT_FILE"



    return "$VG_SUCCESS"

}
