#!/system/bin/sh
#
# Project Vanguard
# Module Trust Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# Trust storage
#

if [ -z "${VG_RUNTIME_DIR:-}" ]; then

    VG_RUNTIME_DIR="$CORE_DIR/../runtime"

fi


VG_TRUST_FILE="$VG_RUNTIME_DIR/trust.db"



#
# Prepare
#

vg_trust_prepare()
{

    [ -d "$VG_RUNTIME_DIR" ] || mkdir -p "$VG_RUNTIME_DIR"


    [ -f "$VG_TRUST_FILE" ] || touch "$VG_TRUST_FILE"


    [ -f "$VG_TRUST_FILE" ] \
        || return "$VG_ERR_INTERNAL"


    return "$VG_SUCCESS"

}



#
# Add trusted module
#

vg_trust_add()
{

    module="$1"


    [ -n "$module" ] \
        || return "$VG_ERR_INVALID"


    vg_trust_prepare || return $?



    grep -q "^${module}|" "$VG_TRUST_FILE" \
        && return "$VG_SUCCESS"



    printf '%s|trusted\n' \
        "$module" \
        >> "$VG_TRUST_FILE"



    return "$VG_SUCCESS"

}



#
# Block module
#

vg_trust_block()
{

    module="$1"


    [ -n "$module" ] \
        || return "$VG_ERR_INVALID"


    vg_trust_prepare || return $?



    printf '%s|blocked\n' \
        "$module" \
        >> "$VG_TRUST_FILE"



    return "$VG_SUCCESS"

}



#
# Get trust state
#

vg_trust_get()
{

    module="$1"


    [ -n "$module" ] \
        || return "$VG_ERR_INVALID"



    [ -f "$VG_TRUST_FILE" ] \
        || return "$VG_ERR_NOT_FOUND"



    state="$(grep "^${module}|" "$VG_TRUST_FILE" | tail -n 1 | cut -d'|' -f2)"



    [ -n "$state" ] \
        || return "$VG_ERR_NOT_FOUND"



    printf '%s\n' "$state"


    return "$VG_SUCCESS"

}



#
# Verify module
#

vg_trust_check()
{

    module="$1"



    state="$(vg_trust_get "$module")"


    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        return "$VG_ERR_NOT_FOUND"

    fi



    case "$state" in

        trusted)

            return "$VG_SUCCESS"
            ;;


        blocked)

            return "$VG_ERR_PERMISSION"
            ;;


        *)

            return "$VG_ERR_INTERNAL"
            ;;

    esac

}



#
# List trust database
#

vg_trust_list()
{

    vg_trust_prepare || return $?


    cat "$VG_TRUST_FILE"


    return "$VG_SUCCESS"

}



#
# Clear
#

vg_trust_clear()
{

    [ -f "$VG_TRUST_FILE" ] || return "$VG_SUCCESS"


    : > "$VG_TRUST_FILE"


    return "$VG_SUCCESS"

}
