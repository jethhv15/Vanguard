#!/system/bin/sh
#
# Project Vanguard
# Recovery Knowledge Base
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# State
#

VG_KB_FILE="${VG_KB_FILE:-$CORE_DIR/../tests/recovery_kb.db}"

VG_KB_PATTERN=""
VG_KB_STRATEGY=""
VG_KB_SUCCESS=""
VG_KB_CONFIDENCE=""



#
# Prepare
#

vg_recovery_kb_prepare()
{

    dir="$(dirname "$VG_KB_FILE")"

    [ -d "$dir" ] || mkdir -p "$dir" 2>/dev/null

    [ -f "$VG_KB_FILE" ] || touch "$VG_KB_FILE"

    return "$VG_SUCCESS"

}



#
# Reset
#

vg_recovery_kb_reset()
{

    VG_KB_PATTERN=""
    VG_KB_STRATEGY=""
    VG_KB_SUCCESS=""
    VG_KB_CONFIDENCE=""

    return "$VG_SUCCESS"

}



#
# Store knowledge
#

vg_recovery_kb_store()
{

    pattern="$1"
    strategy="$2"
    success="$3"

    vg_recovery_kb_prepare || return $?

    confidence="LOW"

    if [ "$success" -ge 80 ]
    then
        confidence="HIGH"

    elif [ "$success" -ge 50 ]
    then
        confidence="MEDIUM"

    fi

    printf '%s|%s|%s|%s\n' \
        "$pattern" \
        "$strategy" \
        "$success" \
        "$confidence" \
        >> "$VG_KB_FILE"

    return "$VG_SUCCESS"

}



#
# Lookup
#

vg_recovery_kb_lookup()
{

    pattern="$1"

    vg_recovery_kb_reset

    [ -f "$VG_KB_FILE" ] || return "$VG_ERR_NOT_FOUND"

    line=$(grep "^$pattern|" "$VG_KB_FILE" | tail -n 1)

    [ -n "$line" ] || return "$VG_ERR_NOT_FOUND"

    IFS='|' read -r \
        VG_KB_PATTERN \
        VG_KB_STRATEGY \
        VG_KB_SUCCESS \
        VG_KB_CONFIDENCE \
        <<EOF
$line
EOF

    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_kb_report()
{

    printf '%s\n' \
        "PATTERN=$VG_KB_PATTERN"

    printf '%s\n' \
        "STRATEGY=$VG_KB_STRATEGY"

    printf '%s\n' \
        "SUCCESS=$VG_KB_SUCCESS"

    printf '%s\n' \
        "CONFIDENCE=$VG_KB_CONFIDENCE"

    return "$VG_SUCCESS"

}
