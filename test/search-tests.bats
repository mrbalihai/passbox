#!/usr/bin/env bats

load test_helper


@test "search: Returns an entry that contains the search value in the Name " {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|123456";
      echo "Entry 2|entry2@test.com|test1234") | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox search \"Entry 1\""

    assert_line 0 "Name: Entry 1"
}

@test "search: Can return multiple results" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|123456";
      echo "Entry 2|entry2@test.com|test1234") | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox search \"Entry\""

    assert_line 0 "Name: Entry 1"
    assert_line 3 "Name: Entry 2"
}

@test "search: Can return additional fields" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|123456";
      echo "Entry 2|entry2@test.com|test1234|Field 1:field 1 value|Field 2:field 2 value") | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox search \"Entry 2\""

    assert_line 3 "Field 1: field 1 value"
    assert_line 4 "Field 2: field 2 value"
}

@test "search: Displays an error if no search string argument is specified" {
    run ./passbox search

    assert_output "Error: Please specify a string to search for"
}
