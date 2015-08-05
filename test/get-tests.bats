#!/usr/bin/env bats

load test_helper

@test "get: Gets an entry from the passbox file" {
    local db_password="Testing"

    echo "Test Get|Test|Test" | encrypt "$db_password"
    run run_get_entry "Test Get" "$db_password"

    assert_line_contains 3 "Name:     Test Get"
    assert_line_contains 4 "Username: Test"
    assert_line_contains 5 "Password: Test"
}

@test "get: Displays an error message if no 'entry name' argument is specified" {
    run run_get_entry ""

    assert_line_contains 1 "Error: Please specify a string to search for"
}

@test "get: Displays an error message if an entry cannot be found" {
    run run_get_entry "Test"

    assert_line_contains 1 "Error: No passwords found"
}
