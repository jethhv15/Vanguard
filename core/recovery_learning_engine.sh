#!/system/bin/sh
#
# Project Vanguard
# Recovery Learning Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_LEARNING_ACTION=""
VG_LEARNING_ATTEMPTS=0
VG_LEARNING_SUCCESS=0
VG_LEARNING_RATE=0
VG_LEARNING_RECOMMENDATION=""
VG_LEARNING_REASON=""



#
# Reset
#

vg_recovery_learning_reset()
{

    VG_LEARNING_ACTION=""
    VG_LEARNING_ATTEMPTS=0
    VG_LEARNING_SUCCESS=0
    VG_LEARNING_RATE=0
    VG_LEARNING_RECOMMENDATION=""
    VG_LEARNING_REASON=""

    return "$VG_SUCCESS"

}



#
# Analyze recovery result
#

vg_recovery_learning_analyze()
{

    action="$1"
    attempts="$2"
    success="$3"



    vg_recovery_learning_reset



    VG_LEARNING_ACTION="$action"
    VG_LEARNING_ATTEMPTS="$attempts"
    VG_LEARNING_SUCCESS="$success"



    if [ "$attempts" -eq 0 ]
    then

        VG_LEARNING_RATE=0

    else

        VG_LEARNING_RATE=$((success * 100 / attempts))

    fi



    #
    # Learning rules
    #

    if [ "$VG_LEARNING_RATE" -ge 80 ]
    then

        VG_LEARNING_RECOMMENDATION="$action"
        VG_LEARNING_REASON="strategy effective"


        return "$VG_SUCCESS"

    fi



    if [ "$VG_LEARNING_RATE" -lt 30 ]
    then

        case "$action" in

            RETRY)
                VG_LEARNING_RECOMMENDATION="RESTORE"
                ;;

            RESTORE)
                VG_LEARNING_RECOMMENDATION="QUARANTINE"
                ;;

            *)
                VG_LEARNING_RECOMMENDATION="REVIEW"
                ;;

        esac


        VG_LEARNING_REASON="strategy ineffective"


        return "$VG_SUCCESS"

    fi



    VG_LEARNING_RECOMMENDATION="$action"
    VG_LEARNING_REASON="strategy acceptable"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_learning_report()
{

    printf '%s\n' \
        "ACTION=$VG_LEARNING_ACTION"


    printf '%s\n' \
        "ATTEMPTS=$VG_LEARNING_ATTEMPTS"


    printf '%s\n' \
        "SUCCESS=$VG_LEARNING_SUCCESS"


    printf '%s\n' \
        "RATE=$VG_LEARNING_RATE"


    printf '%s\n' \
        "RECOMMENDATION=$VG_LEARNING_RECOMMENDATION"


    printf '%s\n' \
        "REASON=$VG_LEARNING_REASON"


    return "$VG_SUCCESS"

}
