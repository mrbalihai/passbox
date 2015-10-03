#!/usr/bin/env bats

load test_helper

@test "delete: Removes an entry from the passbox file" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    ( echo "$db_password";
      echo "y" ) | ./passbox delete "Entry 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_output "Entry 1|entry1@test.com|pass1234"
}

@test "delete: Displays an error if no entry name argument is specified" {
    run ./passbox delete

    assert_output "Error: Please specify the name of an entry to delete"
}
