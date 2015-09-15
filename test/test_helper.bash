encrypt () {
    gpg --symmetric --armor --batch --yes \
        --command-fd 0 --passphrase "$1" \
        --output $PASSBOX_LOCATION 2>/dev/null
}

decrypt () {
    gpg \
        --decrypt --armor --batch \
        --command-fd 0 --passphrase "${1}" "${2}" 2>/dev/null
}

setup () {

    # Don't screw up env variables if ran locally
    PREV_PASSBOX_LOCATION="$PASSBOX_LOCATION"
    export PASSBOX_LOCATION="./test/passbox.gpg"
}

teardown () {
    PASSBOX_LOCATION="$PREV_PASSBOX_LOCATION"
    if [ -f ./test/passbox.gpg ]; then
        rm ./test/passbox.gpg
    fi
    unset PREV_PASSBOX_LOCATION
}

flunk() {
    { if [ "$#" -eq 0 ]; then
        cat -
      else
          echo "$@"
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

assert_length () {
    local p1=$1
    local p2=$2
    if [ "${#p1}" -ne "${p2}" ]; then
        { echo "expected length: ${p2}"
            echo "actual length:   ${#p1}"
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
        assert_equal "$2" "${lines[$1]}"
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
        assert_contains "${lines[$1]}" "$2"
    else
        local line
        for line in "${lines[@]}"; do
            if [ "$line" == *"$1"* ]; then return 0; fi
        done
        flunk "expected line \`$1'"
    fi
}

assert_line_length () {
    if [ "$1" -ge 0 ] 2>/dev/null; then
        assert_length ${lines[$1]} "$2"
    else
        flunk "No line number >1 specified"
    fi
}

assert_line_count () {
    local num_lines="${#lines[@]}"
    if [ "$1" -ne "$num_lines" ]; then
        flunk "output has $num_lines lines, not $1"
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

assert_file_doesnt_exist () {
    local file="$1"
    if [ -f $file ]; then
        { echo "file exists: ${1}"
        } | flunk
    fi
}

assert_file_exists () {
    local file="$1"
    if ![ -f $file ]; then
        { echo "file does not exist: ${1}"
        } | flunk
    fi
}
