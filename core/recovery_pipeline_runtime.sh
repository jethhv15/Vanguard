#!/system/bin/sh
#
# Project Vanguard
# Recovery Pipeline Runtime
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_strategy_manager.sh"
. "$CORE_DIR/recovery_policy_adaptation.sh"



#
# State
#

VG_RUNTIME_STAGE=""
VG_RUNTIME_STATUS="READY"



#
# Execute stage
#

vg_runtime_execute_stage()
{

    stage="$1"

    VG_RUNTIME_STAGE="$stage"

    case "$stage" in

        STRATEGY)

            rm -f "$VG_STRATEGY_FILE"

            vg_strategy_prepare || return $?

            vg_strategy_register "RESTORE" "95" || return $?
            vg_strategy_register "ROLLBACK" "80" || return $?
            vg_strategy_register "RETRY" "50" || return $?

            vg_strategy_select_best || return $?
            ;;

        POLICY)

            vg_policy_adapt \
                "$VG_SELECTED_STRATEGY" \
                "$VG_STRATEGY_SCORE" \
                || return $?

            ;;

    esac

    return "$VG_SUCCESS"

}



#
# Run pipeline
#

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



#
# Status
#

vg_runtime_status()
{

    printf '%s\n' "$VG_RUNTIME_STATUS"

}



#
# Current stage
#

vg_runtime_stage()
{

    printf '%s\n' "$VG_RUNTIME_STAGE"

}
