#!/system/bin/sh
#
# Project Vanguard
# Recovery Transaction Boundary
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


#
# Transaction State
#

VG_RECOVERY_TX_STATE="idle"
VG_RECOVERY_TX_ACTION=""
VG_RECOVERY_TX_TARGET=""
VG_RECOVERY_TX_PREVIOUS_STATE=""


#
# Set state
#

vg_recovery_tx_set_state()
{

    VG_RECOVERY_TX_STATE="$1"

    return "$VG_SUCCESS"

}



#
# Begin
#

vg_recovery_tx_begin()
{

    action="$1"
    target="$2"


    [ -n "$action" ] || return "$VG_ERR_INVALID"



    VG_RECOVERY_TX_ACTION="$action"
    VG_RECOVERY_TX_TARGET="$target"

    VG_RECOVERY_TX_PREVIOUS_STATE="ready"


    vg_recovery_tx_set_state \
        "running"


    return "$VG_SUCCESS"

}



#
# Commit
#

vg_recovery_tx_commit()
{

    [ "$VG_RECOVERY_TX_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"


    vg_recovery_tx_set_state \
        "committed"


    return "$VG_SUCCESS"

}



#
# Rollback
#

vg_recovery_tx_rollback()
{

    [ "$VG_RECOVERY_TX_STATE" = "running" ] \
        || return "$VG_ERR_INVALID"


    vg_recovery_tx_set_state \
        "rolled_back"


    return "$VG_SUCCESS"

}



#
# Reset
#

vg_recovery_tx_reset()
{

    VG_RECOVERY_TX_STATE="idle"
    VG_RECOVERY_TX_ACTION=""
    VG_RECOVERY_TX_TARGET=""
    VG_RECOVERY_TX_PREVIOUS_STATE=""


    return "$VG_SUCCESS"

}



#
# Status
#

vg_recovery_tx_status()
{

    printf '%s\n' \
        "$VG_RECOVERY_TX_STATE"

}
