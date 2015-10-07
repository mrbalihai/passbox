#!/usr/bin/env bats

load test_helper

@test "get: Gets a formatted entry from the passbox file" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get \"Entry 2\""

    assert_line 0 "Name: Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password: 1234pass"
}

@test "get: Can return additional fields" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass|Field 1:Field 1 value|Field 2:Field 2 value" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get \"Entry 2\""

    assert_line 0 "Name: Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password: 1234pass"
    assert_line 3 "Field 1: Field 1 value"
    assert_line 4 "Field 2: Field 2 value"
}

@test "get: Displays an error message if no 'entry name' argument is specified" {
    run ./passbox get

    assert_output "Error: Please specify the name of an entry to get"
}

@test "get: Displays an error message if an entry cannot be found" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get \"Entry 3\""

    assert_line 0 "Error: No entries found"
}

@test "get: Displays an error message invalid commandline argument passed" {
    run bash -c "echo \"$db_password\" | ./passbox get --invalid-argument \"Entry 3\""

    assert_line 0 "Error: Invalid option (--invalid-argument)"
}

@test "get: Displays copied to clipboard message when (shortform) clipboard commandline argument passed" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get -c \"Entry 2\""

    assert_line 0 "Name: Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password copied to clipboard"
}

@test "get: Displays copied to clipboard message when (longform) clipboard commandline argument passed" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get --clipboard \"Entry 2\""

    assert_line 0 "Name: Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password copied to clipboard"
}

@test "get: Can return additional fields when clipboard commandline argument passed" {
    local db_password="test"

    ( echo "Entry 1|entry1@test.com|pass1234";
      echo "Entry 2|entry2@test.com|1234pass|Field 1:Field 1 value|Field 2:Field 2 value" ) | encrypt "$db_password"

    run bash -c "echo \"$db_password\" | ./passbox get -c \"Entry 2\""

    assert_line 0 "Name: Entry 2"
    assert_line 1 "Username: entry2@test.com"
    assert_line 2 "Password copied to clipboard"
    assert_line 3 "Field 1: Field 1 value"
    assert_line 4 "Field 2: Field 2 value"
}
