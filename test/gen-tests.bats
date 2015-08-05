#!/usr/bin/env bats

load test_helper

@test "gen: Generates a 20 character password by default" {
    run run_gen_pass

    #TODO: Extra character possibly from newline
    assert_line_length 2 21
}

@test "gen: Generates a password of a given length" {
    run run_gen_pass 30

    #TODO: Extra character possibly from newline
    assert_line_length 2 31
}
