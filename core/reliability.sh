#!/system/bin/sh
#
# Project Vanguard
# Module Reliability Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# State
#

VG_RELIABILITY_MODULE=""
VG_RELIABILITY_TOTAL=0
VG_RELIABILITY_SUCCESS=0
VG_RELIABILITY_FAILED=0
VG_RELIABILITY_SCORE=0
VG_RELIABILITY_STATUS="unknown"



#
# Reset
#

vg_reliability_reset()
{

    VG_RELIABILITY_MODULE=""
    VG_RELIABILITY_TOTAL=0
    VG_RELIABILITY_SUCCESS=0
    VG_RELIABILITY_FAILED=0
    VG_RELIABILITY_SCORE=0
    VG_RELIABILITY_STATUS="unknown"

    return "$VG_SUCCESS"

}



#
# Calculate
#

vg_reliability_calculate()
{

    module="$1"
    file="$2"


    vg_reliability_reset


    VG_RELIABILITY_MODULE="$module"



    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"



    VG_RELIABILITY_TOTAL=$(
        grep -c "^MODULE=$module" "$file"
    )



    VG_RELIABILITY_SUCCESS=$(
        grep -A6 "^MODULE=$module" "$file" \
        | grep -c "^RESULT=SUCCESS"
    )



    VG_RELIABILITY_FAILED=$(
        grep -A6 "^MODULE=$module" "$file" \
        | grep -c "^RESULT=FAILED"
    )



    if [ "$VG_RELIABILITY_TOTAL" -eq 0 ]
    then

        VG_RELIABILITY_SCORE=0
        VG_RELIABILITY_STATUS="unknown"

        return "$VG_SUCCESS"

    fi



    VG_RELIABILITY_SCORE=$(
        expr "$VG_RELIABILITY_SUCCESS" \* 100 / "$VG_RELIABILITY_TOTAL"
    )



    if [ "$VG_RELIABILITY_SCORE" -ge 90 ]
    then

        VG_RELIABILITY_STATUS="trusted"


    elif [ "$VG_RELIABILITY_SCORE" -ge 50 ]
    then

        VG_RELIABILITY_STATUS="warning"


    else

        VG_RELIABILITY_STATUS="risky"

    fi



    return "$VG_SUCCESS"

}



#
# Getters
#

vg_reliability_score()
{

    printf '%s\n' \
        "$VG_RELIABILITY_SCORE"

}



vg_reliability_status()
{

    printf '%s\n' \
        "$VG_RELIABILITY_STATUS"

}



vg_reliability_report()
{

    printf '%s\n' \
        "MODULE=$VG_RELIABILITY_MODULE"

    printf '%s\n' \
        "TOTAL=$VG_RELIABILITY_TOTAL"

    printf '%s\n' \
        "SUCCESS=$VG_RELIABILITY_SUCCESS"

    printf '%s\n' \
        "FAILED=$VG_RELIABILITY_FAILED"

    printf '%s\n' \
        "SCORE=$VG_RELIABILITY_SCORE"

    printf '%s\n' \
        "STATUS=$VG_RELIABILITY_STATUS"

}
