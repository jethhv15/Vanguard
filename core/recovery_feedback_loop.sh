#!/system/bin/sh
#
# Project Vanguard
# Recovery Feedback Loop Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# State
#

VG_FEEDBACK_ACTION=""
VG_FEEDBACK_EXPECTED=""
VG_FEEDBACK_ACTUAL=""
VG_FEEDBACK_SCORE=""
VG_FEEDBACK_LEARNING=""



#
# Reset
#

vg_feedback_reset()
{

    VG_FEEDBACK_ACTION=""
    VG_FEEDBACK_EXPECTED=""
    VG_FEEDBACK_ACTUAL=""
    VG_FEEDBACK_SCORE=""
    VG_FEEDBACK_LEARNING=""

    return "$VG_SUCCESS"

}



#
# Evaluate feedback
#

vg_feedback_process()
{

    action="$1"
    expected="$2"
    actual="$3"



    vg_feedback_reset



    VG_FEEDBACK_ACTION="$action"
    VG_FEEDBACK_EXPECTED="$expected"
    VG_FEEDBACK_ACTUAL="$actual"



    if [ "$expected" = "$actual" ]
    then

        VG_FEEDBACK_SCORE="100"
        VG_FEEDBACK_LEARNING="CONFIRMED"

    else

        VG_FEEDBACK_SCORE="50"
        VG_FEEDBACK_LEARNING="ADJUST_REQUIRED"

    fi



    return "$VG_SUCCESS"

}



#
# Generate learning signal
#

vg_feedback_learning_signal()
{

    printf '%s\n' \
        "ACTION=$VG_FEEDBACK_ACTION"

    printf '%s\n' \
        "EXPECTED=$VG_FEEDBACK_EXPECTED"

    printf '%s\n' \
        "ACTUAL=$VG_FEEDBACK_ACTUAL"

    printf '%s\n' \
        "SCORE=$VG_FEEDBACK_SCORE"

    printf '%s\n' \
        "LEARNING=$VG_FEEDBACK_LEARNING"

}
