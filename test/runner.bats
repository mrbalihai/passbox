#!/usr/bin/env bats

PASSBOX_LOCATION="./test/passbox.gpg"

@test "Creates a new passbox file if it doesn't exist" {
    run ./test/new.exp
    [ -f ./test/passbox.gpg ]
}


