#!/usr/bin/env bats

load test_helper

@test "remove-field: Removes an existing field from an existing entry" {
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass|MyField:MyFieldValue|My Second Field:My Second Field Value" ) | encrypt "$db_password"

    echo "$db_password" | ./passbox remove-field "Entry 2" "MyField" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "Entry 1|entry1@test.com|pass1234"
    assert_line 1 "Entry 2|entry2@test.com|1234pass|My Second Field:My Second Field Value"
}

@test "remove-field: Displays an error if no entry name argument is specified" {
    run ./passbox remove-field

    assert_output "Error: Please specify the name of an entry to remove a field from"
}

@test "remove-field: Displays an error if no field name argument is specified" {
    run ./passbox remove-field "Test"

    assert_output "Error: Please specify the name of a field to remove"
}
