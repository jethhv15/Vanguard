#!/system/bin/sh
#
# Project Vanguard
# Recovery Monitoring & Telemetry Layer
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# State
#

VG_TELEMETRY_FILE="${VG_TELEMETRY_FILE:-/tmp/vanguard_recovery_telemetry.log}"

VG_TELEMETRY_EVENT=""
VG_TELEMETRY_ACTION=""
VG_TELEMETRY_STATE=""
VG_TELEMETRY_RESULT=""
VG_TELEMETRY_TIME=""



#
# Prepare
#

vg_telemetry_prepare()
{

    dir="$(dirname "$VG_TELEMETRY_FILE")"


    [ -d "$dir" ] || mkdir -p "$dir" 2>/dev/null


    [ -f "$VG_TELEMETRY_FILE" ] || touch "$VG_TELEMETRY_FILE"


    return "$VG_SUCCESS"

}



#
# Reset
#

vg_telemetry_reset()
{

    VG_TELEMETRY_EVENT=""
    VG_TELEMETRY_ACTION=""
    VG_TELEMETRY_STATE=""
    VG_TELEMETRY_RESULT=""
    VG_TELEMETRY_TIME=""


    return "$VG_SUCCESS"

}



#
# Record event
#

vg_telemetry_record()
{

    event="$1"
    action="$2"
    state="$3"
    result="$4"



    vg_telemetry_prepare || return $?



    VG_TELEMETRY_EVENT="$event"
    VG_TELEMETRY_ACTION="$action"
    VG_TELEMETRY_STATE="$state"
    VG_TELEMETRY_RESULT="$result"
    VG_TELEMETRY_TIME="$(date '+%Y%m%d%H%M%S')"



    cat >> "$VG_TELEMETRY_FILE" <<EOF
EVENT=$event
ACTION=$action
STATE=$state
RESULT=$result
TIME=$VG_TELEMETRY_TIME
---
EOF



    return "$VG_SUCCESS"

}



#
# Count events
#

vg_telemetry_count()
{

    event="$1"


    [ -f "$VG_TELEMETRY_FILE" ] || return 0


    grep -c "^EVENT=$event$" \
        "$VG_TELEMETRY_FILE"


}



#
# Report
#

vg_telemetry_report()
{

    printf '%s\n' \
        "EVENT=$VG_TELEMETRY_EVENT"


    printf '%s\n' \
        "ACTION=$VG_TELEMETRY_ACTION"


    printf '%s\n' \
        "STATE=$VG_TELEMETRY_STATE"


    printf '%s\n' \
        "RESULT=$VG_TELEMETRY_RESULT"


    printf '%s\n' \
        "TIME=$VG_TELEMETRY_TIME"


    return "$VG_SUCCESS"

}
