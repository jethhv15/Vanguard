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
# Integrity state
#

VG_AUDIT_SEQUENCE=0
VG_AUDIT_LAST_HASH="0000000000000000"



#
# Prepare
#

vg_audit_prepare()
{

    [ -d "$VG_RUNTIME_DIR" ] || mkdir -p "$VG_RUNTIME_DIR" 2>/dev/null


    [ -f "$VG_AUDIT_FILE" ] || : > "$VG_AUDIT_FILE"


    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Sync chain state from existing log
#

vg_audit_sync_state()
{

    [ -f "$VG_AUDIT_FILE" ] || return "$VG_ERR_NOT_FOUND"


    last="$(tail -n 1 "$VG_AUDIT_FILE" 2>/dev/null)"


    if [ -n "$last" ]; then

        VG_AUDIT_SEQUENCE="$(printf '%s\n' "$last" | cut -d'|' -f1)"

        VG_AUDIT_LAST_HASH="$(printf '%s\n' "$last" | cut -d'|' -f9)"

    fi


    return "$VG_SUCCESS"

}



#
# Hash
#

vg_audit_hash()
{

    input="$1"


    if command -v sha256sum >/dev/null 2>&1; then

        printf '%s' "$input" \
            | sha256sum \
            | cut -d' ' -f1

        return "$VG_SUCCESS"

    fi



    if command -v toybox >/dev/null 2>&1; then

        printf '%s' "$input" \
            | toybox sha256sum \
            | cut -d' ' -f1

        return "$VG_SUCCESS"

    fi



    printf '%s' "$input" \
        | cksum \
        | cut -d' ' -f1


    return "$VG_SUCCESS"

}



#
# Write
#

vg_audit_write()
{

    event="$1"
    module="$2"
    old_state="$3"
    new_state="$4"
    result="$5"


    [ -n "$event" ] \
        || return "$VG_ERR_INVALID"



    vg_audit_prepare \
        || return $?



    vg_audit_sync_state \
        >/dev/null 2>&1



    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"


    VG_AUDIT_SEQUENCE=$((VG_AUDIT_SEQUENCE + 1))



    record="${VG_AUDIT_SEQUENCE}|${timestamp}|${event}|${module}|${old_state}|${new_state}|${result}|${VG_AUDIT_LAST_HASH}"


    hash="$(vg_audit_hash "$record")"



    printf '%s|%s\n' \
        "$record" \
        "$hash" \
        >> "$VG_AUDIT_FILE"



    VG_AUDIT_LAST_HASH="$hash"



    return "$VG_SUCCESS"

}



#
# Read
#

vg_audit_read()
{

    vg_audit_prepare || return $?


    cat "$VG_AUDIT_FILE"


    return "$VG_SUCCESS"

}



#
# Filter
#

vg_audit_filter()
{

    event="$1"


    [ -n "$event" ] \
        || return "$VG_ERR_INVALID"



    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    while IFS= read -r line
    do

        case "$line" in

            *"|${event}|"*)

                printf '%s\n' "$line"

                ;;

        esac


    done < "$VG_AUDIT_FILE"



    return "$VG_SUCCESS"

}



#
# Last
#

vg_audit_last()
{

    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"


    tail -n 1 "$VG_AUDIT_FILE"


    return "$VG_SUCCESS"

}



#
# Clear
#

vg_audit_clear()
{

    vg_audit_prepare || return $?


    : > "$VG_AUDIT_FILE"


    VG_AUDIT_SEQUENCE=0
    VG_AUDIT_LAST_HASH="0000000000000000"


    return "$VG_SUCCESS"

}



#
# Verify integrity
#

vg_audit_verify()
{

    [ -f "$VG_AUDIT_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    previous_hash="0000000000000000"
    expected_sequence=1



    while IFS='|' read -r seq timestamp event module old_state new_state result prev_hash hash
    do


        [ "$seq" = "$expected_sequence" ] \
            || return "$VG_ERR_INTERNAL"



        [ "$prev_hash" = "$previous_hash" ] \
            || return "$VG_ERR_INTERNAL"



        record="${seq}|${timestamp}|${event}|${module}|${old_state}|${new_state}|${result}|${prev_hash}"


        calculated="$(vg_audit_hash "$record")"



        [ "$calculated" = "$hash" ] \
            || return "$VG_ERR_INTERNAL"



        previous_hash="$hash"

        expected_sequence=$((expected_sequence + 1))


    done < "$VG_AUDIT_FILE"



    return "$VG_SUCCESS"

}
