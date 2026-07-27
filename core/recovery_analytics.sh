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

VG_RECOVERY_ANALYTICS_TOTAL=0
VG_RECOVERY_ANALYTICS_SUCCESS=0
VG_RECOVERY_ANALYTICS_FAILED=0



#
# Reset
#

vg_recovery_analytics_reset()
{

    VG_RECOVERY_ANALYTICS_TOTAL=0
    VG_RECOVERY_ANALYTICS_SUCCESS=0
    VG_RECOVERY_ANALYTICS_FAILED=0

    return "$VG_SUCCESS"

}



#
# Analyze History
#

vg_recovery_analytics_scan()
{

    file="$1"


    vg_recovery_analytics_reset


    [ -f "$file" ] \
        || return "$VG_ERR_NOT_FOUND"



    VG_RECOVERY_ANALYTICS_TOTAL=$(
        grep -c "^TIME=" "$file"
    )



    VG_RECOVERY_ANALYTICS_SUCCESS=$(
        grep -c "^RESULT=SUCCESS" "$file"
    )



    VG_RECOVERY_ANALYTICS_FAILED=$(
        grep -c "^RESULT=FAILED" "$file"
    )



    return "$VG_SUCCESS"

}



#
# Getters
#

vg_recovery_analytics_total()
{

    printf '%s\n' \
        "$VG_RECOVERY_ANALYTICS_TOTAL"

}



vg_recovery_analytics_success()
{

    printf '%s\n' \
        "$VG_RECOVERY_ANALYTICS_SUCCESS"

}



vg_recovery_analytics_failed()
{

    printf '%s\n' \
        "$VG_RECOVERY_ANALYTICS_FAILED"

}



#
# Report
#

vg_recovery_analytics_report()
{

    printf '%s\n' \
        "TOTAL=$VG_RECOVERY_ANALYTICS_TOTAL"


    printf '%s\n' \
        "SUCCESS=$VG_RECOVERY_ANALYTICS_SUCCESS"


    printf '%s\n' \
        "FAILED=$VG_RECOVERY_ANALYTICS_FAILED"

}
