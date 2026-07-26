#!/system/bin/sh
#
# Project Vanguard
# Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/scanner.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/planner.sh"
. "$CORE_DIR/lifecycle.sh"
. "$CORE_DIR/executor.sh"
. "$CORE_DIR/hooks.sh"
. "$CORE_DIR/service.sh"
. "$CORE_DIR/event.sh"
. "$CORE_DIR/callback.sh"



vg_engine_start()
{

    vg_runtime_is_initialized || return "$VG_ERR_INTERNAL"



    #
    # Reset registry
    #

    vg_registry_reset || return $?



    #
    # Discover modules
    #

    vg_scan_modules || return $?



    OLD_IFS=$IFS
    IFS='
'



    #
    # Load module metadata
    #

    for module in $VG_SCANNED_MODULES
    do


        vg_load_module "$module" || {

            IFS=$OLD_IFS
            return $?

        }



        manifest="$module/module.prop"



        vg_parse_manifest "$manifest" || {

            IFS=$OLD_IFS
            return $?

        }




        vg_registry_add \
            "$VG_MODULE_ID" \
            "$module" \
            "$VG_MODULE_DEPENDS" || {


                IFS=$OLD_IFS
                return $?


            }


    done



    IFS=$OLD_IFS



    #
    # Build dependency startup plan
    #

    vg_planner_build_all || return $?




    #
    # Apply resolved order
    #

    vg_registry_reorder \
        "$VG_STARTUP_PLAN" || return $?




    #
    # Execute lifecycle
    #

    vg_executor_start || return $?




    return "$VG_SUCCESS"
}
