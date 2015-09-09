#!/usr/bin/env bats

load test_helper

@test "update: Updates an existing entry in the passbox file" {
    local new_entry_username="updatedentry@test.com"
    local new_entry_pass="newpassword"
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    ( echo "$db_password";
      echo "$new_entry_username";
      echo "n";
      echo "$new_entry_pass" ) | ./passbox update "Entry 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "Entry 1|entry1@test.com|pass1234"
    assert_line 1 "Entry 2|updatedentry@test.com|newpassword"
}

@test "update: Updates an existing entry in the passbox file that has a additional field" {
    local new_entry_username="updatedentry@test.com"
    local new_entry_pass="newpassword"
    local db_password="password 123456"

    ( echo "Entry 1|entry1@test.com|pass1234|Foo:Bar";
      echo "Entry 2|entry2@test.com|1234pass|Foo:Baz" ) | encrypt "$db_password"

    ( echo "$db_password";
      echo "$new_entry_username";
      echo "n";
      echo "$new_entry_pass" ) | ./passbox update "Entry 2" >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "Entry 1|entry1@test.com|pass1234|Foo:Bar"
    assert_line 1 "Entry 2|updatedentry@test.com|newpassword|Foo:Baz"
}

@test "update: Displays an error if no entry name argument is specified" {
    run ./passbox update

    assert_output "Error: Please specify the name of an entry to update"
}
