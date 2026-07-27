#!/system/bin/sh
#
# Project Vanguard
# Recovery Knowledge Integrator
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/recovery_knowledge_base.sh" ] && . "$CORE_DIR/recovery_knowledge_base.sh"



#
# State
#

VG_INTEGRATOR_PATTERN=""
VG_INTEGRATOR_ACTION=""
VG_INTEGRATOR_CONFIDENCE=""
VG_INTEGRATOR_SOURCE=""
VG_INTEGRATOR_REASON=""



#
# Reset
#

vg_recovery_integrator_reset()
{

    VG_INTEGRATOR_PATTERN=""
    VG_INTEGRATOR_ACTION=""
    VG_INTEGRATOR_CONFIDENCE=""
    VG_INTEGRATOR_SOURCE=""
    VG_INTEGRATOR_REASON=""

    return "$VG_SUCCESS"

}



#
# Integrate knowledge
#

vg_recovery_integrate_knowledge()
{

    pattern="$1"
    default_action="$2"


    vg_recovery_integrator_reset



    VG_INTEGRATOR_PATTERN="$pattern"



    #
    # Query knowledge
    #

    if vg_recovery_kb_lookup "$pattern" >/dev/null 2>&1
    then

        VG_INTEGRATOR_ACTION="$VG_KB_STRATEGY"
        VG_INTEGRATOR_CONFIDENCE="$VG_KB_CONFIDENCE"
        VG_INTEGRATOR_SOURCE="knowledge_base"
        VG_INTEGRATOR_REASON="previous successful strategy"


        return "$VG_SUCCESS"

    fi



    #
    # Fallback
    #

    VG_INTEGRATOR_ACTION="$default_action"
    VG_INTEGRATOR_CONFIDENCE="LOW"
    VG_INTEGRATOR_SOURCE="policy"
    VG_INTEGRATOR_REASON="no previous knowledge"



    return "$VG_SUCCESS"

}



#
# Compare decision
#

vg_recovery_integrator_compare()
{

    current="$1"
    learned="$2"



    if [ "$current" = "$learned" ]
    then

        VG_INTEGRATOR_REASON="decision matches knowledge"

    else

        VG_INTEGRATOR_REASON="knowledge override applied"

    fi


    return "$VG_SUCCESS"

}



#
# Report
#

vg_recovery_integrator_report()
{

    printf '%s\n' \
        "PATTERN=$VG_INTEGRATOR_PATTERN"


    printf '%s\n' \
        "ACTION=$VG_INTEGRATOR_ACTION"


    printf '%s\n' \
        "CONFIDENCE=$VG_INTEGRATOR_CONFIDENCE"


    printf '%s\n' \
        "SOURCE=$VG_INTEGRATOR_SOURCE"


    printf '%s\n' \
        "REASON=$VG_INTEGRATOR_REASON"


    return "$VG_SUCCESS"

}
