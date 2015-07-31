#!/usr/bin/env bats

load test_helper

@test "get: Gets an entry from the passbox file" {
    local entry_name=Test Get
    local entry_username=Test
    local entry_password=Test
    local db_password=Testing

    run new_entry $entry_name $entry_username $entry_password $db_password
    run get_entry $entry_name $db_password

    assert_line_contains 3 "Name:     Test"
    assert_line_contains 4 "Username: Test"
    assert_line_contains 5 "Password: Test"
}

