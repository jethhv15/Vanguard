#!/system/bin/sh
#
# Project Vanguard
# Module State Machine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"


#
# Runtime State
#

VG_CURRENT_MODULE_STATE=""


#
# Internal
#

vg_state_can_transition() {

    from="$1"
    to="$2"


    case "$from:$to" in

        discovered:validated)
            return 0
            ;;

        validated:loaded)
            return 0
            ;;

        loaded:started)
            return 0
            ;;

        started:stopped)
            return 0
            ;;

        *)
            return 1
            ;;

    esac
}


#
# Public API
#

vg_state_get() {

    printf '%s\n' "$VG_CURRENT_MODULE_STATE"

}


vg_state_set() {

    new_state="$1"

    [ -n "$new_state" ] || return "$VG_ERR_INVALID"


    #
    # Initial state
    #

    if [ -z "$VG_CURRENT_MODULE_STATE" ]; then

        VG_CURRENT_MODULE_STATE="$new_state"

        return "$VG_SUCCESS"

    fi


    vg_state_can_transition \
        "$VG_CURRENT_MODULE_STATE" \
        "$new_state"

    if [ "$?" -ne 0 ]; then
        return "$VG_ERR_INVALID"
    fi


    VG_CURRENT_MODULE_STATE="$new_state"

    return "$VG_SUCCESS"
}
