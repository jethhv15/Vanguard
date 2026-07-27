#!/system/bin/sh
#
# Project Vanguard
# Recovery Policy Adaptation Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# State
#

VG_POLICY_ACTION=""
VG_POLICY_PRIORITY=""
VG_POLICY_CONFIDENCE=""
VG_POLICY_REASON=""



#
# Reset
#

vg_policy_adaptation_reset()
{

    VG_POLICY_ACTION=""
    VG_POLICY_PRIORITY=""
    VG_POLICY_CONFIDENCE=""
    VG_POLICY_REASON=""

    return "$VG_SUCCESS"

}



#
# Adapt policy
#

vg_policy_adapt()
{

    action="$1"
    success_rate="$2"


    vg_policy_adaptation_reset



    VG_POLICY_ACTION="$action"



    if [ "$success_rate" -ge 90 ]
    then

        VG_POLICY_PRIORITY="VERY_HIGH"
        VG_POLICY_CONFIDENCE="95"
        VG_POLICY_REASON="strategy proven reliable"


    elif [ "$success_rate" -ge 60 ]
    then

        VG_POLICY_PRIORITY="HIGH"
        VG_POLICY_CONFIDENCE="75"
        VG_POLICY_REASON="acceptable performance"


    else

        VG_POLICY_PRIORITY="LOW"
        VG_POLICY_CONFIDENCE="30"
        VG_POLICY_REASON="strategy requires downgrade"

    fi



    return "$VG_SUCCESS"

}



#
# Compare policy
#

vg_policy_should_switch()
{

    current="$1"
    alternative="$2"


    if [ "$VG_POLICY_PRIORITY" = "LOW" ]
    then

        VG_POLICY_REASON="switch recommended from $current to $alternative"

        return 0

    fi


    return 1

}



#
# Report
#

vg_policy_report()
{

    printf '%s\n' \
        "ACTION=$VG_POLICY_ACTION"


    printf '%s\n' \
        "PRIORITY=$VG_POLICY_PRIORITY"


    printf '%s\n' \
        "CONFIDENCE=$VG_POLICY_CONFIDENCE"


    printf '%s\n' \
        "REASON=$VG_POLICY_REASON"

}
