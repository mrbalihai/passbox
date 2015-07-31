new_entry () {
    /usr/bin/expect -d <<EOF
spawn ./passbox new
expect "Name: "
send -- "$1\r"
expect "Username: "
send -- "$2\r"
expect "Generate password? (y/n, default: y) "
send -- "n\r"
expect "Enter password for \"$2\": "
send "$3\r"
expect "Enter password to unlock $PASSBOX_LOCATION: "
send "$4\r"
expect eof
EOF
}

get_entry () {
    /usr/bin/expect <<EOF
spawn ./passbox get $1
expect "Enter password to unlock $PASSBOX_LOCATION: "
send "$2\r"
expect eof
EOF
}

setup () {
    PREV_PASSBOX_LOCATION="$PASSBOX_LOCATION"
    export PASSBOX_LOCATION="./test/passbox.gpg"
}

teardown () {
    rm ./test/passbox.gpg
    if [ -z $PREV_PASSBOX_LOCATION ]; then
        export PASSBOX_LOCATION="$PREV_PASSBOX_LOCATION"
    else
        unset PASSBOX_LOCATION
    fi
    unset PREV_PASSBOX_LOCATION
}

flunk() {
    { if [ "$#" -eq 0 ]; then cat -
      else echo "$@"
      fi
    } >&2
    return 1
}

assert_success() {
    if [ "$status" -ne 0 ]; then
        flunk "command failed with exit status $status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_failure() {
    if [ "$status" -eq 0 ]; then
        flunk "expected failed exit status"
    elif [ "$#" -gt 0 ]; then
        assert_output "$1"
    fi
}

assert_equal() {
    if [ "$1" != "$2" ]; then
        { echo "expected: ${1}"
            echo "actual:   ${2}"
        } | flunk
    fi
}

assert_contains() {
    if ![ "$1" == *"$2" ]; then
        { echo "expected: ${1}"
            echo "actual:   ${2}"
        } | flunk
    fi
}

assert_output() {
    local expected
    if [ $# -eq 0 ]; then expected="$(cat -)"
    else expected="$1"
    fi
    assert_equal "$expected" "$output"
}

assert_line () {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        assert_equal "|$2|" "|${lines[$1]}|"
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" = "$1" ]; then return 0; fi
        done
        flunk "expected line \`$1'"
    fi
}

assert_line_contains () {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        assert_contains "|$2|" "|${lines[$1]}|"
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" == *"$1" ]; then return 0; fi
        done
        flunk "expected line \`$1'"
    fi
}

refute_line () {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        local num_lines="${#lines[@]}"
        if [ "$1" -lt "$num_lines" ]; then
            flunk "output has $num_lines lines"
        fi
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" = "$1" ]; then
                flunk "expected to not find line \`$line'"
            fi
        done
    fi
}

assert () {
    if ! "$@"; then
        flunk "failed: $@"
    fi
}

assert_file_exists () {
    local file="$1"
    if ![ -f $file ]; then
        { echo "file does noto exist: ${1}"
        } | flunk
    fi
}

assert_output_contains () {
    local expected="$1"
    if [ -z "$expected" ]; then
        echo "assert_output_contains needs an argument" >&2
        return 1
    fi
    echo "$output" | $(type -p ggrep grep | head -1) -F "$expected" >/dev/null || {
    { echo "expected output to contain $expected"
        echo "actual: $output"
    } | flunk
}
                                        }
