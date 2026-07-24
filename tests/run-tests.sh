#!/system/bin/sh
#
# Project Vanguard
# Test Runner
#

TEST_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$TEST_DIR/testlib.sh"

for testcase in "$TEST_DIR"/cases/*.sh
do
    [ -f "$testcase" ] || continue

    printf '\n'
    printf 'Running %s\n' "$(basename "$testcase")"

    . "$testcase"
done

vg_test_summary
