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
# Legacy single state
#

VG_CURRENT_MODULE_STATE=""


#
# Multi module states
#

VG_MODULE_STATES=""


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



vg_state_find_module() {

    target="$1"


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_MODULE_STATES
    do

        id="${entry%%|*}"


        if [ "$id" = "$target" ]; then

            IFS="$old_ifs"
            return "$VG_SUCCESS"

        fi

    done


    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



#
# Public API
#

vg_state_get() {

    #
    # Legacy mode
    #

    if [ "$#" -eq 0 ]; then

        printf '%s\n' "$VG_CURRENT_MODULE_STATE"

        return "$VG_SUCCESS"

    fi


    #
    # Module mode
    #

    module="$1"


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_MODULE_STATES
    do

        id="${entry%%|*}"
        state="${entry##*|}"


        if [ "$id" = "$module" ]; then

            printf '%s\n' "$state"

            IFS="$old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$old_ifs"

    return "$VG_ERR_NOT_FOUND"
}



vg_state_set() {


    #
    # Legacy mode
    #

    if [ "$#" -eq 1 ]; then

        new_state="$1"


        [ -n "$new_state" ] || return "$VG_ERR_INVALID"


        if [ -z "$VG_CURRENT_MODULE_STATE" ]; then

            VG_CURRENT_MODULE_STATE="$new_state"

            return "$VG_SUCCESS"

        fi


        vg_state_can_transition \
            "$VG_CURRENT_MODULE_STATE" \
            "$new_state"


        [ "$?" -eq 0 ] || return "$VG_ERR_INVALID"


        VG_CURRENT_MODULE_STATE="$new_state"


        return "$VG_SUCCESS"

    fi



    #
    # Module mode
    #

    module="$1"
    new_state="$2"


    [ -n "$module" ] || return "$VG_ERR_INVALID"
    [ -n "$new_state" ] || return "$VG_ERR_INVALID"


    old_state=""


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_MODULE_STATES
    do

        id="${entry%%|*}"
        state="${entry##*|}"


        if [ "$id" = "$module" ]; then

            old_state="$state"
            break

        fi

    done


    IFS="$old_ifs"



    if [ -z "$old_state" ]; then

        VG_MODULE_STATES="${VG_MODULE_STATES:+$VG_MODULE_STATES
}${module}|${new_state}"

        return "$VG_SUCCESS"

    fi



    vg_state_can_transition \
        "$old_state" \
        "$new_state"


    [ "$?" -eq 0 ] || return "$VG_ERR_INVALID"



    new_list=""


    old_ifs="$IFS"
    IFS='
'


    for entry in $VG_MODULE_STATES
    do

        id="${entry%%|*}"


        if [ "$id" = "$module" ]; then

            entry="${module}|${new_state}"

        fi


        if [ -z "$new_list" ]; then
            new_list="$entry"
        else
            new_list="${new_list}
${entry}"
        fi

    done


    IFS="$old_ifs"


    VG_MODULE_STATES="$new_list"


    return "$VG_SUCCESS"
}
