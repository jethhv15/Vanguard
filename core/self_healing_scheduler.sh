#!/system/bin/sh
#
# Project Vanguard
# Self Healing Scheduler
#

if [ -z "${CORE_DIR:-}" ]; then
    CORE_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
fi


. "$CORE_DIR/constants.sh"


[ -f "$CORE_DIR/self_healing_orchestrator.sh" ] && . "$CORE_DIR/self_healing_orchestrator.sh"



#
# State
#

VG_HEAL_QUEUE="${VG_HEAL_QUEUE:-/tmp/vanguard_healing.queue}"

VG_SCHED_MODULE=""
VG_SCHED_ACTION=""
VG_SCHED_STATUS=""



#
# Prepare
#

vg_self_heal_scheduler_prepare()
{

    dir="$(dirname "$VG_HEAL_QUEUE")"


    [ -d "$dir" ] \
        || mkdir -p "$dir" 2>/dev/null


    [ -f "$VG_HEAL_QUEUE" ] \
        || touch "$VG_HEAL_QUEUE"


    return "$VG_SUCCESS"

}



#
# Queue Task
#

vg_self_heal_schedule_add()
{

    module="$1"
    failures="$2"
    critical="$3"


    vg_self_heal_scheduler_prepare \
        || return $?



    if grep -q "^$module|" "$VG_HEAL_QUEUE"
    then
        return "$VG_ERR_GENERAL"
    fi



    printf '%s|%s|%s|pending\n' \
        "$module" \
        "$failures" \
        "$critical" \
        >> "$VG_HEAL_QUEUE"


    return "$VG_SUCCESS"

}



#
# Run Queue
#

vg_self_heal_scheduler_run()
{

    vg_self_heal_scheduler_prepare \
        || return $?



    tmp="${VG_HEAL_QUEUE}.tmp"


    > "$tmp"



    while IFS='|' read -r module failures critical status
    do

        [ -n "$module" ] || continue



        if [ "$status" = "pending" ]
        then

            vg_self_heal_orchestrate \
                "$module" \
                "$failures" \
                "$critical"


            VG_SCHED_MODULE="$module"
            VG_SCHED_ACTION="$VG_ORCH_DECISION"



            if [ "$VG_ORCH_RESULT" = "SUCCESS" ]
            then

                VG_SCHED_STATUS="completed"

            else

                VG_SCHED_STATUS="failed"

            fi



        else

            VG_SCHED_STATUS="$status"

        fi



        printf '%s|%s|%s|%s\n' \
            "$module" \
            "$failures" \
            "$critical" \
            "$VG_SCHED_STATUS" \
            >> "$tmp"


    done < "$VG_HEAL_QUEUE"



    mv "$tmp" "$VG_HEAL_QUEUE"



    return "$VG_SUCCESS"

}



#
# Status
#

vg_self_heal_scheduler_status()
{

    printf '%s\n' \
        "MODULE=$VG_SCHED_MODULE"


    printf '%s\n' \
        "ACTION=$VG_SCHED_ACTION"


    printf '%s\n' \
        "STATUS=$VG_SCHED_STATUS"


    return "$VG_SUCCESS"

}
