#!/system/bin/sh
#
# Project Vanguard
# Engine Core
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/config.sh"
. "$CORE_DIR/runtime.sh"
. "$CORE_DIR/scanner.sh"
. "$CORE_DIR/loader.sh"
. "$CORE_DIR/parser.sh"
. "$CORE_DIR/registry.sh"
. "$CORE_DIR/planner.sh"
. "$CORE_DIR/lifecycle.sh"
. "$CORE_DIR/executor.sh"
. "$CORE_DIR/audit.sh"



#
# Engine State
#

if [ -z "${VG_ENGINE_STATE:-}" ]; then
    VG_ENGINE_STATE="$VG_ENGINE_IDLE"
fi



vg_engine_set_state()
{

    VG_ENGINE_STATE="$1"

    return "$VG_SUCCESS"

}



vg_engine_status()
{

    printf '%s\n' "$VG_ENGINE_STATE"

    return "$VG_SUCCESS"

}



#
# Audit
#

vg_engine_audit()
{

    event="$1"
    result="$2"


    if command -v vg_audit_write >/dev/null 2>&1
    then

        vg_audit_write \
            "$event" \
            "engine" \
            "" \
            "$VG_ENGINE_STATE" \
            "$result" \
            >/dev/null 2>&1

    fi


    return "$VG_SUCCESS"

}



#
# Start
#

vg_engine_start()
{


    if [ "$VG_ENGINE_STATE" = "$VG_ENGINE_READY" ]
    then

        return "$VG_ERR_INVALID"

    fi



    vg_engine_set_state "$VG_ENGINE_BOOTING"



    vg_config_load >/dev/null 2>&1
    rc=$?

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_registry_reset
    rc=$?

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_scan_modules
    rc=$?

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    OLD_IFS="$IFS"
    IFS='
'



    for module in $VG_SCANNED_MODULES
    do


        vg_load_module "$module"
        rc=$?

        if [ "$rc" -ne "$VG_SUCCESS" ]; then

            IFS="$OLD_IFS"

            vg_engine_set_state "$VG_ENGINE_FAILED"

            return "$rc"

        fi



        vg_parse_manifest "$module/module.prop"
        rc=$?

        if [ "$rc" -ne "$VG_SUCCESS" ]; then

            IFS="$OLD_IFS"

            vg_engine_set_state "$VG_ENGINE_FAILED"

            return "$rc"

        fi



        vg_registry_add \
            "$VG_MODULE_ID" \
            "$module" \
            "$VG_MODULE_DEPENDS"

        rc=$?


        if [ "$rc" -ne "$VG_SUCCESS" ]; then

            IFS="$OLD_IFS"

            vg_engine_set_state "$VG_ENGINE_FAILED"

            return "$rc"

        fi


    done



    IFS="$OLD_IFS"



    vg_planner_build_all
    rc=$?

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_registry_reorder \
        "$VG_STARTUP_PLAN"

    rc=$?

    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_executor_start
    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_engine_set_state "$VG_ENGINE_READY"



    vg_engine_audit \
        "ENGINE_READY" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Stop
#

vg_engine_stop()
{


    vg_executor_stop
    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_engine_set_state "$VG_ENGINE_FAILED"

        return "$rc"

    fi



    vg_engine_set_state "$VG_ENGINE_IDLE"



    return "$VG_SUCCESS"

}
