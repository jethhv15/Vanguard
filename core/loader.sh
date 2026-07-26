#!/system/bin/sh
#
# Project Vanguard
# Module Loader
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/trust.sh" ] && . "$CORE_DIR/trust.sh"
[ -f "$CORE_DIR/permission.sh" ] && . "$CORE_DIR/permission.sh"
[ -f "$CORE_DIR/capability_manager.sh" ] && . "$CORE_DIR/capability_manager.sh"



VG_LOADED_MODULES=""
VG_LOADED_MODULE_COUNT=0



vg_loader_security_check()
{

    module="$1"
    module_id="$2"


    [ -f "$module/security.prop" ] || return "$VG_SUCCESS"



    if command -v vg_trust_check >/dev/null 2>&1
    then
        vg_trust_check "$module_id" || return $?
    fi



    if command -v vg_permission_check >/dev/null 2>&1
    then

        while IFS='=' read -r key value
        do

            [ "$key" = "permission" ] || continue

            vg_permission_check "$value" || return $?

        done < "$module/security.prop"

    fi



    if command -v vg_capability_check >/dev/null 2>&1
    then

        while IFS='=' read -r key value
        do

            [ "$key" = "capability" ] || continue

            vg_capability_check "$value" || return $?

        done < "$module/security.prop"

    fi


    return "$VG_SUCCESS"

}



vg_load_module()
{

    module_path="$1"



    [ -d "$module_path" ] \
        || return "$VG_ERR_NOT_FOUND"



    manifest="$module_path/module.prop"


    [ -f "$manifest" ] \
        || return "$VG_ERR_INVALID"



    module_id=""


    while IFS='=' read -r key value
    do

        case "$key" in

            id)
                module_id="$value"
                ;;

        esac

    done < "$manifest"



    [ -n "$module_id" ] \
        || return "$VG_ERR_INVALID"



    vg_loader_security_check \
        "$module_path" \
        "$module_id"


    rc=$?


    [ "$rc" -eq "$VG_SUCCESS" ] \
        || return "$rc"



    #
    # Load module implementation
    #

    if [ -f "$module_path/module.sh" ]; then

        . "$module_path/module.sh"

    elif [ -f "$module_path/main.sh" ]; then

        . "$module_path/main.sh"

    fi



    #
    # Register loaded module
    #

    if [ -z "$VG_LOADED_MODULES" ]; then

        VG_LOADED_MODULES="${module_id}|${module_path}"

    else

        VG_LOADED_MODULES="${VG_LOADED_MODULES}
${module_id}|${module_path}"

    fi



    VG_LOADED_MODULE_COUNT=$((VG_LOADED_MODULE_COUNT + 1))


    return "$VG_SUCCESS"

}
