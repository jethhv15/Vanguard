#!/system/bin/sh
#
# Project Vanguard
# Module Dispatcher
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/context.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/state.sh"
. "$CORE_DIR/callback.sh"
. "$CORE_DIR/audit.sh"



#
# Internal
#

vg_dispatch_audit()
{

    event="$1"
    module="$2"
    action="$3"
    result="$4"


    command -v vg_audit_write >/dev/null 2>&1 || return "$VG_SUCCESS"


    vg_audit_write \
        "$event" \
        "$module" \
        "$action" \
        "" \
        "$result" \
        >/dev/null 2>&1


    return "$VG_SUCCESS"

}



#
# Public API
#

vg_dispatch_module()
{

    module_id="$1"
    action="$2"


    [ -n "$module_id" ] || return "$VG_ERR_INVALID"
    [ -n "$action" ] || return "$VG_ERR_INVALID"



    module_path="$(vg_registry_get_path "$module_id")" \
        || return $?



    manifest="$module_path/module.prop"



    vg_parse_manifest "$manifest" \
        || return $?



    vg_context_set "$module_path" \
        || return $?



    callback="vg_${VG_MODULE_ID}_${action}"



    #
    # Audit dispatch request
    #

    vg_dispatch_audit \
        "MODULE_DISPATCH" \
        "$module_id" \
        "$action" \
        "$VG_SUCCESS"



    #
    # State validation
    #

    current_state="$(vg_state_get_module "$module_id" 2>/dev/null)"



    case "$action" in

        init)

            if [ -n "$current_state" ]; then

                vg_dispatch_audit \
                    "DISPATCH_REJECTED" \
                    "$module_id" \
                    "$action" \
                    "$VG_ERR_INVALID"


                vg_context_clear

                return "$VG_ERR_INVALID"

            fi

            ;;



        start)

            if [ "$current_state" != "loaded" ]; then

                vg_dispatch_audit \
                    "DISPATCH_REJECTED" \
                    "$module_id" \
                    "$action" \
                    "$VG_ERR_INVALID"


                vg_context_clear

                return "$VG_ERR_INVALID"

            fi

            ;;



        stop)

            if [ "$current_state" != "started" ]; then

                vg_dispatch_audit \
                    "DISPATCH_REJECTED" \
                    "$module_id" \
                    "$action" \
                    "$VG_ERR_INVALID"


                vg_context_clear

                return "$VG_ERR_INVALID"

            fi

            ;;



        *)

            vg_dispatch_audit \
                "DISPATCH_REJECTED" \
                "$module_id" \
                "$action" \
                "$VG_ERR_INVALID"


            vg_context_clear

            return "$VG_ERR_INVALID"

            ;;

    esac



    #
    # Execute callback
    #

    vg_invoke_callback "$callback"

    result=$?



    if [ "$result" -ne "$VG_SUCCESS" ]; then


        vg_dispatch_audit \
            "CALLBACK_FAILED" \
            "$module_id" \
            "$action" \
            "$result"



        vg_context_clear

        return "$result"

    fi



    #
    # Update module state
    #

    case "$action" in

        init)

            vg_state_set \
                "$module_id" \
                "$VG_MODULE_STATE_LOADED"

            ;;


        start)

            vg_state_set \
                "$module_id" \
                "$VG_MODULE_STATE_STARTED"

            ;;


        stop)

            vg_state_set \
                "$module_id" \
                "$VG_MODULE_STATE_STOPPED"

            ;;

    esac



    result=$?



    if [ "$result" -ne "$VG_SUCCESS" ]; then

        vg_dispatch_audit \
            "STATE_UPDATE_FAILED" \
            "$module_id" \
            "$action" \
            "$result"


        vg_context_clear

        return "$result"

    fi



    vg_dispatch_audit \
        "CALLBACK_SUCCESS" \
        "$module_id" \
        "$action" \
        "$VG_SUCCESS"



    vg_context_clear



    return "$VG_SUCCESS"

}
