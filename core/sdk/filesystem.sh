#!/system/bin/sh
#
# Project Vanguard
# SDK Filesystem API
#

vg_fs_exists() {

    path="$1"

    [ -n "$path" ] || return 1

    [ -e "$path" ]
}

vg_fs_is_file() {

    path="$1"

    [ -n "$path" ] || return 1

    [ -f "$path" ]
}

vg_fs_is_dir() {

    path="$1"

    [ -n "$path" ] || return 1

    [ -d "$path" ]
}
