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


    case "$action" in

        init)

            vg_state_set "$VG_MODULE_STATE_LOADED" \
                || {
                    vg_context_clear
                    return $?
                }

            ;;


        start)

            [ "$VG_CURRENT_MODULE_STATE" = "$VG_MODULE_STATE_LOADED" ] \
                || {
                    vg_context_clear
                    return "$VG_ERR_INVALID"
                }

            ;;


        stop)

            [ "$VG_CURRENT_MODULE_STATE" = "$VG_MODULE_STATE_STARTED" ] \
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


    vg_invoke_callback "$callback"
    result=$?


    if [ "$result" -ne "$VG_SUCCESS" ]; then

        vg_context_clear
        return "$result"

    fi


    case "$action" in

        init)
            vg_state_set "$VG_MODULE_STATE_LOADED"
            ;;

        start)
            vg_state_set "$VG_MODULE_STATE_STARTED"
            ;;

        stop)
            vg_state_set "$VG_MODULE_STATE_STOPPED"
            ;;

    esac


    vg_context_clear


    return "$VG_SUCCESS"
}
