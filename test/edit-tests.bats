#!/usr/bin/env bats

load test_helper

@test "update: Updates an existing entry in the passbox file" {
    local new_entry_username="test@test.com"
    local new_entry_pass="newpassword"
    local db_password=Test

    ( echo "Test Update|Test|Test";
      echo "Test 2|Test|Test" ) | encrypt "$db_password"
    ( echo "$db_password";
      echo "$new_entry_username";
      echo "n";
      echo "$new_entry_pass" ) | ./passbox update "Test 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "Test Update|Test|Test"
    assert_line 1 "Test 2|test@test.com|newpassword"
}

