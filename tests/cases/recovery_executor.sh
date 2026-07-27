#!/system/bin/sh
#
# Project Vanguard
# Recovery Executor Tests
#

. "$TEST_DIR/testlib.sh"
. "$CORE_DIR/constants.sh"
. "$CORE_DIR/recovery_executor.sh"


#
# Mock module environment
#

VG_RECOVERY_ACTION="RETRY_MODULE"
VG_RECOVERY_TARGET="example"


VG_EXECUTOR_STATE="running"


#
# Mock module functions
#

RECOVERY_TEST_STOP=0
RECOVERY_TEST_INIT=0
RECOVERY_TEST_START=0


vg_dispatch_module()
{

    module="$1"
    action="$2"


    [ "$module" = "example" ] || return "$VG_ERR_NOT_FOUND"


    case "$action" in

        stop)

            RECOVERY_TEST_STOP=1
            return "$VG_SUCCESS"

            ;;


        init)

            RECOVERY_TEST_INIT=1
            return "$VG_SUCCESS"

            ;;


        start)

            RECOVERY_TEST_START=1
            return "$VG_SUCCESS"

            ;;


        *)

            return "$VG_ERR_INVALID"

            ;;

    esac

}



#
# Execute recovery
#

vg_recovery_execute

rc=$?


vg_assert_return_code \
    "$VG_SUCCESS" \
    "$rc" \
    "Recovery executor should complete module retry"



#
# Validate actions
#

vg_assert_equal \
    "1" \
    "$RECOVERY_TEST_STOP" \
    "Recovery executor should stop module"



vg_assert_equal \
    "1" \
    "$RECOVERY_TEST_INIT" \
    "Recovery executor should initialize module"



vg_assert_equal \
    "1" \
    "$RECOVERY_TEST_START" \
    "Recovery executor should start module"



#
# Unsupported action
#

VG_RECOVERY_ACTION="UNKNOWN"
VG_RECOVERY_TARGET="example"


vg_recovery_execute

rc=$?


vg_assert_return_code \
    "$VG_ERR_INVALID" \
    "$rc" \
    "Recovery executor should reject unknown action"
