#!/system/bin/sh
#
# Project Vanguard
# Recovery Analytics Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_ANALYTICS_TOTAL=0
VG_ANALYTICS_SUCCESS=0
VG_ANALYTICS_FAILED=0
VG_ANALYTICS_RATE=0
VG_ANALYTICS_SCORE=0
VG_ANALYTICS_BEST_ACTION=""



#
# Reset
#

vg_recovery_analytics_reset()
{

    VG_ANALYTICS_TOTAL=0
    VG_ANALYTICS_SUCCESS=0
    VG_ANALYTICS_FAILED=0
    VG_ANALYTICS_RATE=0
    VG_ANALYTICS_SCORE=0
    VG_ANALYTICS_BEST_ACTION=""


    return "$VG_SUCCESS"

}



#
# Analyze telemetry
#

vg_recovery_analytics_run()
{

    logfile="$1"


    vg_recovery_analytics_reset



    [ -f "$logfile" ] || return "$VG_ERR_NOT_FOUND"



    VG_ANALYTICS_SUCCESS=$(grep -c "^RESULT=SUCCESS$" "$logfile")
    VG_ANALYTICS_FAILED=$(grep -c "^RESULT=FAILED$" "$logfile")



    VG_ANALYTICS_TOTAL=$(
        expr \
        "$VG_ANALYTICS_SUCCESS" + \
        "$VG_ANALYTICS_FAILED"
    )



    if [ "$VG_ANALYTICS_TOTAL" -gt 0 ]
    then

        VG_ANALYTICS_RATE=$(
            expr \
            "$VG_ANALYTICS_SUCCESS" \* 100 / "$VG_ANALYTICS_TOTAL"
        )

    fi



    if [ "$VG_ANALYTICS_RATE" -ge 90 ]
    then

        VG_ANALYTICS_SCORE="HIGH"

    elif [ "$VG_ANALYTICS_RATE" -ge 50 ]
    then

        VG_ANALYTICS_SCORE="MEDIUM"

    else

        VG_ANALYTICS_SCORE="LOW"

    fi



    VG_ANALYTICS_BEST_ACTION=$(
        grep "^ACTION=" "$logfile" | \
        tail -n 1 | \
        cut -d= -f2
    )



    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_analytics_report()
{

    printf '%s\n' \
        "TOTAL=$VG_ANALYTICS_TOTAL"


    printf '%s\n' \
        "SUCCESS=$VG_ANALYTICS_SUCCESS"


    printf '%s\n' \
        "FAILED=$VG_ANALYTICS_FAILED"


    printf '%s\n' \
        "SUCCESS_RATE=$VG_ANALYTICS_RATE"


    printf '%s\n' \
        "SCORE=$VG_ANALYTICS_SCORE"


    printf '%s\n' \
        "BEST_ACTION=$VG_ANALYTICS_BEST_ACTION"


    return "$VG_SUCCESS"

}
