#!/system/bin/sh
#
# Project Vanguard
# Test Runner
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_DIR="$(CDPATH= cd -- "$TEST_DIR/.." && pwd)"
CORE_DIR="$PROJECT_DIR/core"
CONFIG_DIR="$PROJECT_DIR/config"
MODULE_DIR="$PROJECT_DIR/modules"

export TEST_DIR
export PROJECT_DIR
export CORE_DIR
export CONFIG_DIR
export MODULE_DIR

. "$TEST_DIR/testlib.sh"

for testcase in "$TEST_DIR"/cases/*.sh
do
    [ -f "$testcase" ] || continue

    printf '\n'
    printf 'Running %s\n' "$(basename "$testcase")"

    . "$testcase"
done

vg_test_summary
