#!/system/bin/sh
#
# Project Vanguard
# Runtime Resume Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"
. "$CORE_DIR/persistence.sh"
. "$CORE_DIR/snapshot.sh"
. "$CORE_DIR/recovery.sh"
. "$CORE_DIR/audit.sh"



#
# Runtime Resume State
#

VG_RESUME_STATE="$VG_RESUME_IDLE"



#
# Internal
#

vg_resume_set_state()
{

    VG_RESUME_STATE="$1"

    return "$VG_SUCCESS"

}



vg_resume_audit()
{

    event="$1"
    result="$2"


    vg_audit_write \
        "$event" \
        "resume" \
        "" \
        "$VG_RESUME_STATE" \
        "$result"


    return "$VG_SUCCESS"

}



#
# Check persistence
#

vg_resume_check_persistence()
{

    if [ -f "$VG_PERSIST_FILE" ]; then

        return "$VG_SUCCESS"

    fi


    return "$VG_ERR_NOT_FOUND"

}



#
# Validate snapshot
#

vg_resume_validate_snapshot()
{

    vg_snapshot_exists

    rc=$?


    if [ "$rc" -ne "$VG_SUCCESS" ]; then

        return "$VG_ERR_NOT_FOUND"

    fi


    return "$VG_SUCCESS"

}



#
# Restore runtime
#

vg_resume_restore()
{

    vg_resume_set_state "$VG_RESUME_RESTORING"



    vg_persistence_load >/dev/null 2>&1

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then


        vg_resume_set_state "$VG_RESUME_FAILED"



        vg_resume_audit \
            "RESUME_FAILED" \
            "$rc"



        return "$rc"

    fi



    vg_resume_set_state "$VG_RESUME_RESTORED"



    vg_resume_audit \
        "RESUME_SUCCESS" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Recovery fallback
#

vg_resume_recover()
{

    vg_resume_set_state "$VG_RESUME_RECOVERY"



    vg_recovery_execute

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then


        vg_resume_set_state "$VG_RESUME_FAILED"



        vg_resume_audit \
            "RECOVERY_FAILED" \
            "$rc"



        return "$rc"

    fi



    vg_resume_set_state "$VG_RESUME_RESTORED"



    vg_resume_audit \
        "RECOVERY_SUCCESS" \
        "$VG_SUCCESS"



    return "$VG_SUCCESS"

}



#
# Public API
#

vg_resume_start()
{

    vg_resume_set_state "$VG_RESUME_CHECKING"



    #
    # Fresh boot
    #

    vg_resume_check_persistence

    rc=$?



    if [ "$rc" -ne "$VG_SUCCESS" ]; then


        vg_resume_set_state "$VG_RESUME_FRESH"



        vg_resume_audit \
            "RESUME_EMPTY" \
            "$VG_SUCCESS"



        return "$VG_SUCCESS"

    fi



    #
    # Restore existing runtime
    #

    vg_resume_validate_snapshot

    rc=$?



    if [ "$rc" -eq "$VG_SUCCESS" ]; then


        vg_resume_restore


        return $?

    fi



    #
    # Recovery path
    #

    vg_resume_recover


    return $?

}



#
# Status
#

vg_resume_status()
{

    printf '%s\n' \
        "$VG_RESUME_STATE"


    return "$VG_SUCCESS"

}
