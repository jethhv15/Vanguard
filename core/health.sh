#!/system/bin/sh
#
# Project Vanguard
# Health Monitor
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

[ -f "$CORE_DIR/audit.sh" ] && . "$CORE_DIR/audit.sh"


#
# Health State
#

VG_HEALTH_STATUS="unknown"
VG_HEALTH_REPORT=""


#
# Internal
#

vg_health_append()
{
    line="$1"

    if [ -z "$VG_HEALTH_REPORT" ]; then
        VG_HEALTH_REPORT="$line"
    else
        VG_HEALTH_REPORT="${VG_HEALTH_REPORT}
$line"
    fi
}


#
# Engine Check
#

vg_health_check_engine()
{

    if [ "$VG_ENGINE_STATE" = "$VG_ENGINE_READY" ]; then

        vg_health_append \
            "ENGINE      : READY"

        return "$VG_SUCCESS"

    fi


    if [ "$VG_ENGINE_STATE" = "$VG_ENGINE_IDLE" ]; then

        vg_health_append \
            "ENGINE      : IDLE"

        return "$VG_SUCCESS"

    fi


    vg_health_append \
        "ENGINE      : FAILED"

    return "$VG_ERR_GENERAL"

}



#
# Runtime Check
#

vg_health_check_runtime()
{

    if [ "${VG_RUNTIME_INITIALIZED}" = "true" ] &&
       [ "${VG_RUNTIME_DISCOVERED}" = "true" ] &&
       [ "${VG_RUNTIME_VALIDATED}" = "true" ]; then


        vg_health_append \
            "RUNTIME     : VALID"

        return "$VG_SUCCESS"

    fi


    vg_health_append \
        "RUNTIME     : INVALID"


    return "$VG_ERR_GENERAL"

}



#
# Executor Check
#

vg_health_check_executor()
{

    if [ "${VG_EXECUTOR_STATE}" = "running" ]; then

        vg_health_append \
            "EXECUTOR    : RUNNING"

        return "$VG_SUCCESS"

    fi


    vg_health_append \
        "EXECUTOR    : STOPPED"


    return "$VG_ERR_GENERAL"

}



#
# Module Check
#

vg_health_check_modules()
{

    count="${VG_LOADED_MODULE_COUNT:-0}"


    if [ "$count" -gt 0 ]; then

        vg_health_append \
            "MODULES     : $count LOADED"

        return "$VG_SUCCESS"

    fi


    vg_health_append \
        "MODULES     : NONE"


    return "$VG_ERR_GENERAL"

}



#
# Audit Check
#

vg_health_check_audit()
{

    command -v vg_audit_verify >/dev/null 2>&1 || {

        vg_health_append \
            "AUDIT       : UNKNOWN"

        return "$VG_SUCCESS"

    }


    vg_audit_verify

    if [ "$?" -eq "$VG_SUCCESS" ]; then

        vg_health_append \
            "AUDIT       : OK"

        return "$VG_SUCCESS"

    fi


    vg_health_append \
        "AUDIT       : FAILED"


    return "$VG_ERR_GENERAL"

}



#
# Public API
#

vg_health_check()
{

    VG_HEALTH_REPORT=""
    failed=0


    vg_health_check_engine || failed=1
    vg_health_check_runtime || failed=1
    vg_health_check_executor || failed=1
    vg_health_check_modules || failed=1
    vg_health_check_audit || failed=1



    if [ "$failed" -eq 0 ]; then

        VG_HEALTH_STATUS="healthy"

        vg_health_append \
            "HEALTH      : PASS"

        return "$VG_SUCCESS"

    fi



    VG_HEALTH_STATUS="degraded"

    vg_health_append \
        "HEALTH      : DEGRADED"


    return "$VG_ERR_GENERAL"

}



vg_health_report()
{

    printf '%s\n' "$VG_HEALTH_REPORT"

}
