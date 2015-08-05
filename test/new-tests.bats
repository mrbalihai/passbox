#!/usr/bin/env bats

load test_helper

@test "new: Creates a new passbox file if it doesn't exist" {
    local entry_name=Test
    local entry_username=Test
    local entry_password=Test
    local db_password=Test

    run run_new_entry $entry_name $entry_username $entry_password $db_password

    assert_file_exists ./test/passbox.gpg
}

@test "new: Creates a new entry in the passbox file" {
    local entry_name=Test
    local entry_username=Test
    local entry_password=Test
    local db_password=Test

    run run_new_entry $entry_name $entry_username $entry_password $db_password
    run run_get_entry $entry_name $db_password

    assert_line_contains 3 "Name:     Test"
    assert_line_contains 4 "Username: Test"
    assert_line_contains 5 "Password: Test"
}

