#!/system/bin/sh
#
# Project Vanguard
# Recovery Rules Engine
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi

. "$CORE_DIR/constants.sh"



#
# Default Rules
#

VG_RULE_SAFE_RETRY_LIMIT=3
VG_RULE_WARNING_RETRY_LIMIT=2
VG_RULE_CRITICAL_RETRY_LIMIT=0



#
# Current Rule State
#

VG_RECOVERY_RULE_LEVEL="none"
VG_RECOVERY_RULE_ACTION="NONE"



#
# Reset
#

vg_recovery_rules_reset()
{

    VG_RECOVERY_RULE_LEVEL="none"
    VG_RECOVERY_RULE_ACTION="NONE"

    return "$VG_SUCCESS"

}



#
# Get Retry Limit
#

vg_recovery_rules_retry_limit()
{

    level="$1"


    case "$level" in

        safe)

            printf '%s\n' \
                "$VG_RULE_SAFE_RETRY_LIMIT"

            ;;


        warning)

            printf '%s\n' \
                "$VG_RULE_WARNING_RETRY_LIMIT"

            ;;


        critical)

            printf '%s\n' \
                "$VG_RULE_CRITICAL_RETRY_LIMIT"

            ;;


        *)

            printf '%s\n' \
                "0"

            ;;

    esac


    return "$VG_SUCCESS"

}



#
# Resolve Recovery Action
#

vg_recovery_rules_resolve()
{

    level="$1"


    VG_RECOVERY_RULE_LEVEL="$level"


    case "$level" in


        safe)

            VG_RECOVERY_RULE_ACTION="RETRY_MODULE"

            ;;


        warning)

            VG_RECOVERY_RULE_ACTION="RETRY_MODULE"

            ;;


        critical)

            VG_RECOVERY_RULE_ACTION="RESTORE_SNAPSHOT"

            ;;


        *)

            VG_RECOVERY_RULE_ACTION="NONE"

            ;;

    esac


    return "$VG_SUCCESS"

}



#
# Current Action
#

vg_recovery_rules_action()
{

    printf '%s\n' \
        "$VG_RECOVERY_RULE_ACTION"


    return "$VG_SUCCESS"

}
