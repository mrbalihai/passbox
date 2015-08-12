#!/usr/bin/env bats

load test_helper

@test "delete: Removes an entry from the passbox file" {
    local new_entry_username="test@test.com"
    local new_entry_pass="newpassword"
    local db_password=Test

    ( echo "Test Update|Test|Test";
      echo "Test 2|Test|Test" ) | encrypt "$db_password"

    echo "$db_password" | ./passbox delete "Test 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_output "Test Update|Test|Test"
}

