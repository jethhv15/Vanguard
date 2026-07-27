#!/system/bin/sh
#
# Project Vanguard
# Recovery Strategy Manager
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# State
#

VG_STRATEGY_FILE="${VG_STRATEGY_FILE:-/tmp/vanguard_strategies.db}"

VG_STRATEGY_NAME=""
VG_STRATEGY_SCORE=""
VG_SELECTED_STRATEGY=""



#
# Prepare
#

vg_strategy_prepare()
{

    dir="$(dirname "$VG_STRATEGY_FILE")"

    [ -d "$dir" ] || mkdir -p "$dir" 2>/dev/null

    [ -f "$VG_STRATEGY_FILE" ] || touch "$VG_STRATEGY_FILE"

    return "$VG_SUCCESS"

}



#
# Reset
#

vg_strategy_reset()
{

    VG_STRATEGY_NAME=""
    VG_STRATEGY_SCORE=""
    VG_SELECTED_STRATEGY=""

    return "$VG_SUCCESS"

}



#
# Register strategy
#

vg_strategy_register()
{

    name="$1"
    score="$2"


    vg_strategy_prepare || return $?


    printf '%s|%s\n' \
        "$name" \
        "$score" \
        >> "$VG_STRATEGY_FILE"


    return "$VG_SUCCESS"

}



#
# Select best strategy
#

vg_strategy_select_best()
{

    vg_strategy_reset


    [ -f "$VG_STRATEGY_FILE" ] || \
        return "$VG_ERR_NOT_FOUND"



    best=$(sort -t'|' -k2 -nr "$VG_STRATEGY_FILE" | head -n 1)



    [ -n "$best" ] || \
        return "$VG_ERR_NOT_FOUND"



    IFS='|' read -r \
        VG_STRATEGY_NAME \
        VG_STRATEGY_SCORE \
        <<EOF
$best
EOF



    VG_SELECTED_STRATEGY="$VG_STRATEGY_NAME"



    return "$VG_SUCCESS"

}



#
# Report
#

vg_strategy_report()
{

    printf '%s\n' \
        "STRATEGY=$VG_STRATEGY_NAME"


    printf '%s\n' \
        "SCORE=$VG_STRATEGY_SCORE"


    printf '%s\n' \
        "SELECTED=$VG_SELECTED_STRATEGY"

}
