#!/usr/bin/env bats

load test_helper

@test "new: Creates a new passbox file if it doesn't exist" {
    local entry_name=Test
    local entry_username=Test
    local entry_password=Test
    local db_password=Test

    run bash -c "( echo $entry_name;
                   echo $entry_username;
                   echo n;
                   echo $entry_pasword;
                   echo $db_password; ) | ./passbox new"

    assert_file_exists ./test/passbox.gpg
}

@test "new: Creates a new entry in the passbox file" {
    local entry_name=Test
    local entry_username=Test
    local entry_password=Test
    local db_password=Test

    ( echo "$entry_name";
      echo "$entry_username";
      echo "n";
      echo "$entry_password";
      echo "$db_password"; ) | ./passbox new >/dev/null

    run decrypt "$db_password" "$PASSBOX_LOCATION"

    assert_line 0 "$entry_name|$entry_username|$entry_password"
}

