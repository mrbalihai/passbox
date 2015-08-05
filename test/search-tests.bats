#!/usr/bin/env bats

load test_helper

@test "search: Returns an entry that contains the search value in the Name " {
    local db_password="Testing"

    echo "Entry 1|entry1@test.com|123456\nEntry2|entry2@test.com|test1234" | encrypt "$db_password"
    run run_search_entry "Entry 1" "$db_password"
    assert_line_contains 3 "Name:   Entry 1"
}
