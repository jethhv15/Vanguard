#!/system/bin/sh
#
# Project Vanguard
# Test Library
#

PASS_COUNT=0
FAIL_COUNT=0

vg_test_pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf '[PASS] %s\n' "$1"
}

vg_test_fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    printf '[FAIL] %s\n' "$1"
}

vg_assert_equal() {

    expected="$1"
    actual="$2"
    message="$3"

    if [ "$expected" = "$actual" ]; then
        vg_test_pass "$message"
    else
        vg_test_fail "$message"
        printf '        expected: %s\n' "$expected"
        printf '        actual  : %s\n' "$actual"
    fi
}

vg_assert_true() {

    if eval "$1"; then
        vg_test_pass "$2"
    else
        vg_test_fail "$2"
    fi
}

vg_assert_false() {

    if eval "$1"; then
        vg_test_fail "$2"
    else
        vg_test_pass "$2"
    fi
}

vg_assert_return_code() {

    expected="$1"
    actual="$2"
    message="$3"

    vg_assert_equal "$expected" "$actual" "$message"
}

vg_test_summary() {

    printf '\n'
    printf '=============================\n'
    printf 'Tests Passed : %s\n' "$PASS_COUNT"
    printf 'Tests Failed : %s\n'
    printf '=============================\n'

    [ "$FAIL_COUNT" -eq 0 ]
}
