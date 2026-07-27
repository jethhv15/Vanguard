#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"

VG_RUNTIME_STAGE=""
VG_RUNTIME_STATUS="READY"

vg_runtime_execute_stage()
{
    stage="$1"

    VG_RUNTIME_STAGE="$stage"

    return "$VG_SUCCESS"
}

vg_runtime_run()
{
    VG_RUNTIME_STATUS="RUNNING"

    for stage in \
        DETECTION \
        DECISION \
        STRATEGY \
        EXECUTION \
        VERIFICATION \
        TELEMETRY \
        ANALYTICS \
        OPTIMIZATION \
        POLICY \
        FEEDBACK \
        KNOWLEDGE
    do
        vg_runtime_execute_stage "$stage" || {
            VG_RUNTIME_STATUS="FAILED"
            return 1
        }
    done

    VG_RUNTIME_STATUS="COMPLETE"

    return "$VG_SUCCESS"
}

vg_runtime_status()
{
    printf '%s\n' "$VG_RUNTIME_STATUS"
}

vg_runtime_stage()
{
    printf '%s\n' "$VG_RUNTIME_STAGE"
}
