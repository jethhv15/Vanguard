#!/system/bin/sh
#
# Project Vanguard
# Data Governance Policy
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"



#
# Default policies
#

VG_POLICY_DEFAULT_SEVERITY="INFO"
VG_POLICY_DEFAULT_PROTECTED="false"
VG_POLICY_DEFAULT_RETENTION="30"



#
# Internal policy database
#

VG_POLICY_RULES=""


#
# Reset policies
#

vg_policy_reset()
{

    VG_POLICY_RULES=""


    return "$VG_SUCCESS"

}



#
# Add policy rule
#

vg_policy_add()
{

    event="$1"
    severity="$2"
    protected="$3"
    retention="$4"


    [ -n "$event" ] || return "$VG_ERR_INVALID"


    entry="${event}|${severity}|${protected}|${retention}"


    if [ -z "$VG_POLICY_RULES" ]; then

        VG_POLICY_RULES="$entry"

    else

        VG_POLICY_RULES="${VG_POLICY_RULES}
${entry}"

    fi


    return "$VG_SUCCESS"

}



#
# Get policy
#

vg_policy_get()
{

    event="$1"


    [ -n "$event" ] || return "$VG_ERR_INVALID"


    old_ifs="$IFS"
    IFS='
'


    for rule in $VG_POLICY_RULES
    do

        id="${rule%%|*}"


        if [ "$id" = "$event" ]; then

            printf '%s\n' "$rule"

            IFS="$old_ifs"

            return "$VG_SUCCESS"

        fi

    done


    IFS="$old_ifs"


    printf '%s|%s|%s|%s\n' \
        "$event" \
        "$VG_POLICY_DEFAULT_SEVERITY" \
        "$VG_POLICY_DEFAULT_PROTECTED" \
        "$VG_POLICY_DEFAULT_RETENTION"



    return "$VG_SUCCESS"

}



#
# Get severity
#

vg_policy_severity()
{

    vg_policy_get "$1" | cut -d'|' -f2

}



#
# Check protection
#

vg_policy_protected()
{

    vg_policy_get "$1" | cut -d'|' -f3

}



#
# Get retention
#

vg_policy_retention()
{

    vg_policy_get "$1" | cut -d'|' -f4

}
