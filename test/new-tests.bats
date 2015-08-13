#!/usr/bin/env bats

load test_helper

@test "new: Creates a new passbox file if it doesn't exist" {
    local entry_name="Entry 1"
    local entry_username="entry1@test.com"
    local entry_password="pass1234"
    local db_password="password 12345"

    run bash -c "( echo $entry_name;
                   echo $entry_username;
                   echo n;
                   echo $entry_pasword;
                   echo $db_password; ) | ./passbox new"

    assert_file_exists ./test/passbox.gpg
}

@test "new: Creates a new entry in the passbox file" {
    local entry_name="Entry 1"
    local entry_username="entry1@test.com"
    local entry_password="pass1234"
    local db_password="password 12345"

    ( echo "$entry_name";
      echo "$entry_username";
      echo "n";
      echo "$entry_password";
      echo "$db_password"; ) | ./passbox new >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "$entry_name|$entry_username|$entry_password"
}

