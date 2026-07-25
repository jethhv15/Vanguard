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


TOTAL_PASS=0
TOTAL_FAIL=0


for testcase in "$TEST_DIR"/cases/*.sh
do
    [ -f "$testcase" ] || continue

    printf '\n'
    printf 'Running %s\n' "$(basename "$testcase")"

    sh "$testcase"

    rc=$?

    if [ "$rc" -eq 0 ]; then
        TOTAL_PASS=$((TOTAL_PASS + 1))
    else
        TOTAL_FAIL=$((TOTAL_FAIL + 1))
    fi

done


printf '\n'
printf '=============================\n'
printf 'Test Cases Passed : %s\n' "$TOTAL_PASS"
printf 'Test Cases Failed : %s\n' "$TOTAL_FAIL"
printf '=============================\n'


[ "$TOTAL_FAIL" -eq 0 ]
