[![Build Status](https://travis-ci.org/RobBollons/passbox.svg)](https://travis-ci.org/RobBollons/passbox)

# PASSBOX
## Simple command line password manager using bash and GPG - Work in progress

### PREREQS
    - GnuPG
    - Bash
### USAGE
usage: passbox [action]

Passbox - command line password manager utility

ACTIONS
   get       <entry name>      Get a particular password entry by it's name
   generate                    Generate a new random password
   new                         Prompt to create a new passbox entry
   search    <search pattern>  Search the password database for a particular string, returns the first match
   update    <entry name>      Update an existing entry in the password database
