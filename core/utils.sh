#!/system/bin/sh
#
# Project Vanguard
# Utility Component
#

#
# Load Dependencies
#

. "$(dirname "$0")/constants.sh"

#
# Public Functions
#

vg_command_exists() {
    command -v "$1" >/dev/null 2>&1
    return $?
}

vg_is_empty() {
    [ -z "$1" ]
    return $?
}

vg_is_not_empty() {
    [ -n "$1" ]
    return $?
}
