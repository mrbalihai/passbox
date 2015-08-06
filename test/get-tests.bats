#!/usr/bin/env bats

load test_helper

@test "get: Gets a formatted entry from the passbox file" {
    local db_password="Testing"

    echo "Test Get|Test|Test" | encrypt "$db_password"
    run bash -c "echo \"$db_password\" | ./passbox get \"Test Get\""

    assert_line 0 "Name:     Test Get"
    assert_line 1 "Username: Test"
    assert_line 2 "Password: Test"
}

@test "get: Displays an error message if no 'entry name' argument is specified" {
    run ./passbox get ""

    assert_line 0 "Error: Please specify a string to search for"
}

@test "get: Displays an error message if an entry cannot be found" {
    local db_password="Testing"

    echo "Test Get|Test|Test" | encrypt "$db_password"
    run bash -c "echo \"$db_password\" | ./passbox get \"Test\""

    assert_line 0 "Error: No entries found"
}
