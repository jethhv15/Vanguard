#!/system/bin/sh
#
# Project Vanguard
# Transaction Layer
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"
. "$CORE_DIR/audit.sh"


#
# Transaction State
#

VG_TRANSACTION_STATE="idle"
VG_TRANSACTION_ID=""


#
# Internal
#

vg_transaction_set_state()
{

    VG_TRANSACTION_STATE="$1"

    return "$VG_SUCCESS"

}



vg_transaction_generate_id()
{

    VG_TRANSACTION_ID="$(date '+%Y%m%d%H%M%S')"


    [ -n "$VG_TRANSACTION_ID" ] \
        || return "$VG_ERR_INTERNAL"


    printf '%s\n' "$VG_TRANSACTION_ID"


    return "$VG_SUCCESS"

}



vg_transaction_validate()
{

    [ -n "$VG_TRANSACTION_ID" ] \
        || return "$VG_ERR_INVALID"


    return "$VG_SUCCESS"

}



#
# Public API
#

vg_transaction_begin()
{

    if [ "$VG_TRANSACTION_STATE" != "idle" ]; then

        return "$VG_ERR_GENERAL"

    fi



    vg_transaction_generate_id >/dev/null \
        || return $?



    vg_transaction_set_state "running"



    vg_audit_write \
        "TRANSACTION_BEGIN" \
        "$VG_TRANSACTION_ID" \
        "idle" \
        "running" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_transaction_commit()
{

    [ "$VG_TRANSACTION_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"



    vg_transaction_validate \
        || return $?



    old_state="$VG_TRANSACTION_STATE"



    vg_transaction_set_state "committed"



    vg_audit_write \
        "TRANSACTION_COMMIT" \
        "$VG_TRANSACTION_ID" \
        "$old_state" \
        "committed" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_transaction_rollback()
{

    [ "$VG_TRANSACTION_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"



    vg_transaction_validate \
        || return $?



    old_state="$VG_TRANSACTION_STATE"



    vg_transaction_set_state "rolledback"



    vg_audit_write \
        "TRANSACTION_ROLLBACK" \
        "$VG_TRANSACTION_ID" \
        "$old_state" \
        "rolledback" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



vg_transaction_status()
{

    printf '%s\n' \
        "$VG_TRANSACTION_STATE"


    return "$VG_SUCCESS"

}



vg_transaction_reset()
{

    VG_TRANSACTION_STATE="idle"
    VG_TRANSACTION_ID=""


    return "$VG_SUCCESS"

}
