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


#
# Public API
#

vg_dispatch_module() {

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
    # State validation
    #

    current_state="$(vg_state_get_module "$module_id" 2>/dev/null)"



    case "$action" in

        init)

            if [ -n "$current_state" ]; then
                vg_context_clear
                return "$VG_ERR_INVALID"
            fi

            ;;



        start)

            [ "$current_state" = "loaded" ] \
                || {
                    vg_context_clear
                    return "$VG_ERR_INVALID"
                }

            ;;



        stop)

            [ "$current_state" = "started" ] \
                || {
                    vg_context_clear
                    return "$VG_ERR_INVALID"
                }

            ;;



        *)

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
                "loaded"

            ;;


        start)

            vg_state_set \
                "$module_id" \
                "started"

            ;;


        stop)

            vg_state_set \
                "$module_id" \
                "stopped"

            ;;

    esac



    result=$?



    vg_context_clear



    return "$result"
}
