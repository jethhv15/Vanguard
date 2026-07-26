#!/system/bin/sh
#
# Project Vanguard
# Atomic Recovery Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"
. "$CORE_DIR/transaction.sh"
. "$CORE_DIR/snapshot.sh"


#
# Atomic State
#

VG_ATOMIC_STATE="idle"


#
# Internal
#

vg_atomic_set_state()
{

    VG_ATOMIC_STATE="$1"

    return "$VG_SUCCESS"

}



#
# Public API
#

vg_atomic_begin()
{

    [ "$VG_ATOMIC_STATE" = "idle" ] \
        || return "$VG_ERR_GENERAL"



    vg_snapshot_create

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_atomic_set_state "failed"

        return "$rc"

    fi



    vg_transaction_begin

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_atomic_set_state "failed"

        return "$rc"

    fi



    vg_atomic_set_state "running"



    vg_audit_write \
        "ATOMIC_BEGIN" \
        "runtime" \
        "idle" \
        "running" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_atomic_commit()
{

    [ "$VG_ATOMIC_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"



    vg_transaction_commit

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_atomic_set_state "failed"

        return "$rc"

    fi



    vg_atomic_set_state "committed"



    vg_audit_write \
        "ATOMIC_COMMIT" \
        "runtime" \
        "running" \
        "committed" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_atomic_fail()
{

    [ "$VG_ATOMIC_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"



    vg_transaction_rollback

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_atomic_set_state "failed"

        return "$rc"

    fi



    vg_snapshot_restore

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        vg_atomic_set_state "failed"

        return "$rc"

    fi



    vg_atomic_set_state "rolledback"



    vg_audit_write \
        "ATOMIC_ROLLBACK" \
        "runtime" \
        "running" \
        "rolledback" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_atomic_status()
{

    printf '%s\n' \
        "$VG_ATOMIC_STATE"


    return "$VG_SUCCESS"

}



vg_atomic_reset()
{

    VG_ATOMIC_STATE="idle"


    vg_transaction_reset

    vg_snapshot_clear


    return "$VG_SUCCESS"

}
