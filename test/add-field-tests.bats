#!/usr/bin/env bats

load test_helper

@test "add-field: Adds additional fields to an existing entry" {
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    ( echo "$db_password";
      echo "Field Name";
      echo "Field Value" ) | ./passbox add-field "Entry 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 1 "Entry 2|entry2@test.com|1234pass|Field Name:Field Value"
}

@test "add-field: Adds multiple additional fields to an existing entry" {
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass|Field Name:Field Value" ) | encrypt "$db_password"

    ( echo "$db_password";
      echo "Field 2 Name";
      echo "Field 2 Value" ) | ./passbox add-field "Entry 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 1 "Entry 2|entry2@test.com|1234pass|Field Name:Field Value|Field 2 Name:Field 2 Value"
}

@test "add-field: Displays an error if no entry name argument is specified" {
    run ./passbox update

    assert_output "Error: Please specify the name of an entry to update"
}
