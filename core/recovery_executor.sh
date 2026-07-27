#!/system/bin/sh
#
# Project Vanguard
# Recovery Executor
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/lifecycle.sh"
. "$CORE_DIR/dispatcher.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/recovery_transaction.sh"
. "$CORE_DIR/recovery_snapshot.sh"

VG_RECOVERY_EXECUTION_STATUS="idle"

vg_recovery_executor_set_status()
{
    VG_RECOVERY_EXECUTION_STATUS="$1"
    return "$VG_SUCCESS"
}

vg_recovery_executor_audit()
{
    event="$1"
    result="$2"

    command -v vg_audit_write >/dev/null 2>&1 || return "$VG_SUCCESS"

    vg_audit_write \
        "$event" \
        "recovery_executor" \
        "" \
        "$VG_RECOVERY_EXECUTION_STATUS" \
        "$result" \
        >/dev/null 2>&1

    return "$VG_SUCCESS"
}

vg_recovery_retry_module()
{
    module="$1"

    [ -n "$module" ] || return "$VG_ERR_INVALID"

    vg_dispatch_module "$module" stop >/dev/null 2>&1

    vg_dispatch_module "$module" init
    rc=$?

    [ "$rc" -eq "$VG_SUCCESS" ] || return "$rc"

    vg_dispatch_module "$module" start
}

vg_recovery_execute()
{
    action="${VG_RECOVERY_ACTION:-NONE}"
    target="${VG_RECOVERY_TARGET:-}"

    vg_recovery_tx_begin \
        "$action" \
        "$target"

    rc=$?

    [ "$rc" -eq "$VG_SUCCESS" ] || return "$rc"

    vg_recovery_executor_set_status "running"

    case "$action" in

        RETRY_MODULE)

            vg_recovery_retry_module "$target"
            rc=$?
            ;;

        RESTORE_SNAPSHOT)

            vg_recovery_restore_snapshot "$target"
            rc=$?
            ;;

        NONE)

            rc="$VG_SUCCESS"
            ;;

        *)

            rc="$VG_ERR_INVALID"
            ;;

    esac

    if [ "$rc" -eq "$VG_SUCCESS" ]; then

        vg_recovery_tx_commit || return $?

        vg_recovery_executor_set_status "completed"

        vg_recovery_executor_audit \
            "RECOVERY_SUCCESS" \
            "$VG_SUCCESS"

        return "$VG_SUCCESS"
    fi

    vg_recovery_tx_rollback >/dev/null 2>&1

    vg_recovery_executor_set_status "failed"

    vg_recovery_executor_audit \
        "RECOVERY_FAILED" \
        "$rc"

    return "$rc"
}

vg_recovery_executor_status()
{
    printf '%s\n' "$VG_RECOVERY_EXECUTION_STATUS"
}
