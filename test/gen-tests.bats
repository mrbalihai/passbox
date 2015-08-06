#!/usr/bin/env bats

load test_helper

@test "gen: Generates a 20 character password by default" {
    run bash -c "echo | ./passbox gen"

    assert_line_length 0 20
}

@test "gen: Generates a password of a given length" {
    run bash -c "echo 30 | ./passbox gen"

    assert_line_length 0 30
}
