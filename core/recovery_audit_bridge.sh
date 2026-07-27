#!/system/bin/sh
#
# Project Vanguard
# Recovery Audit Bridge
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_RECOVERY_AUDIT_MODULE=""
VG_RECOVERY_AUDIT_EVENTS=0
VG_RECOVERY_AUDIT_SUCCESS=0
VG_RECOVERY_AUDIT_FAILURE=0



#
# Reset
#

vg_recovery_audit_reset()
{

    VG_RECOVERY_AUDIT_MODULE=""
    VG_RECOVERY_AUDIT_EVENTS=0
    VG_RECOVERY_AUDIT_SUCCESS=0
    VG_RECOVERY_AUDIT_FAILURE=0

    return "$VG_SUCCESS"

}



#
# Sync Audit
#

vg_recovery_audit_sync()
{

    audit_file="$1"
    module="$2"


    [ -f "$audit_file" ] \
        || return "$VG_ERR_NOT_FOUND"



    vg_recovery_audit_reset



    VG_RECOVERY_AUDIT_MODULE="$module"



    while IFS= read -r line
    do

        case "$line" in

            EVENT=*)
                event="${line#EVENT=}"


                VG_RECOVERY_AUDIT_EVENTS=$((VG_RECOVERY_AUDIT_EVENTS + 1))


                ;;


            RESULT=SUCCESS)

                VG_RECOVERY_AUDIT_SUCCESS=$((VG_RECOVERY_AUDIT_SUCCESS + 1))

                ;;


            RESULT=FAILED)

                VG_RECOVERY_AUDIT_FAILURE=$((VG_RECOVERY_AUDIT_FAILURE + 1))

                ;;


        esac


    done < "$audit_file"



    return "$VG_SUCCESS"

}



#
# Bridge
#

vg_recovery_audit_bridge()
{

    audit_file="$1"
    module="$2"



    vg_recovery_audit_sync \
        "$audit_file" \
        "$module"



    return $?

}



#
# Summary
#

vg_recovery_audit_summary()
{

    printf '%s\n' \
        "MODULE=$VG_RECOVERY_AUDIT_MODULE"


    printf '%s\n' \
        "EVENTS=$VG_RECOVERY_AUDIT_EVENTS"


    printf '%s\n' \
        "SUCCESS=$VG_RECOVERY_AUDIT_SUCCESS"


    printf '%s\n' \
        "FAILURE=$VG_RECOVERY_AUDIT_FAILURE"



    return "$VG_SUCCESS"

}
