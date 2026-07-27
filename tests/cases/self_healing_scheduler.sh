#!/system/bin/sh
#
# Project Vanguard
# Self Healing Scheduler Test
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"


VG_HEAL_QUEUE="$TEST_DIR/healing.queue"



. "$CORE_DIR/self_healing_policy.sh"
. "$CORE_DIR/self_healing_executor.sh"
. "$CORE_DIR/self_healing_orchestrator.sh"
. "$CORE_DIR/self_healing_scheduler.sh"



rm -f "$VG_HEAL_QUEUE"



#
# Add task
#

vg_self_heal_schedule_add \
    "test_module" \
    1 \
    false



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Queue add should succeed"



#
# Run scheduler
#

vg_self_heal_scheduler_run



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Scheduler run should succeed"



#
# Check result
#

grep "test_module|1|false|completed" \
    "$VG_HEAL_QUEUE" >/dev/null



vg_assert_equal \
    "$VG_SUCCESS" \
    "$?" \
    "Task should complete"
