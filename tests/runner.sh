#!/bin/sh

test_CreateNewPasswordEntry () {
    ./tests/new.exp > ./tests/new.actual
    assertEquals "$(cat ./tests/new.actual)" "$(cat ./tests/new.expected)"
}

. shunit2-2.0.3/src/shell/shunit2
