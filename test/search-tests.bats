#!/usr/bin/env bats

load test_helper


@test "search: Returns an entry that contains the search value in the Name " {
    local db_password="password 12345"

    ( echo "Entry 1|entry1@test.com|123456";
      echo "Entry 2|entry2@test.com|test1234") | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox search \"Entry 1\""

    assert_line 0 "Name:     Entry 1"
}

@test "search: Can return multiple results" {
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|123456";
      echo "Entry 2|entry2@test.com|test1234") | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox search \"Entry\""

    assert_line 0 "Name:     Entry 1"
    assert_line 3 "Name:     Entry 2"
}

@test "search: Displays an error if no search string argument is specified" {
    run ./passbox search

    assert_output "Error: Please specify a string to search for"
}
