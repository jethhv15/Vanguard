#!/system/bin/sh
#
# Project Vanguard
# Audit Framework
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Audit storage
#

if [ -z "${VG_RUNTIME_DIR:-}" ]; then

    if [ -d "/data/adb" ] && [ -w "/data/adb" ]; then

        VG_RUNTIME_DIR="/data/adb/vanguard/runtime"

    else

        VG_RUNTIME_DIR="$CORE_DIR/../runtime"

    fi

fi


VG_AUDIT_FILE="${VG_RUNTIME_DIR}/audit.log"



#
# Prepare storage
#

vg_audit_prepare()
{

    [ -d "$VG_RUNTIME_DIR" ] || mkdir -p "$VG_RUNTIME_DIR" 2>/dev/null


    if [ ! -f "$VG_AUDIT_FILE" ]; then

        : > "$VG_AUDIT_FILE" 2>/dev/null

    fi


    [ -f "$VG_AUDIT_FILE" ] || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Write audit event
#

vg_audit_write()
{

    event="$1"
    module="$2"
    old_state="$3"
    new_state="$4"
    result="$5"


    [ -n "$event" ] || return "$VG_ERR_INVALID"



    vg_audit_prepare || return $?



    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"



    printf '%s|%s|%s|%s|%s|%s\n' \
        "$timestamp" \
        "$event" \
        "$module" \
        "$old_state" \
        "$new_state" \
        "$result" \
        >> "$VG_AUDIT_FILE"



    return "$VG_SUCCESS"

}



#
# Read audit
#

vg_audit_read()
{

    vg_audit_prepare || return $?


    cat "$VG_AUDIT_FILE"


    return "$VG_SUCCESS"

}
