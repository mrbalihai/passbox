[![Build Status](https://travis-ci.org/RobBollons/passbox.svg)](https://travis-ci.org/RobBollons/passbox)

# PASSBOX
## A simple command line password manager using bash and GPG
High test coverage with minimal dependencies.

Credit to [drduh/pwd.sh](https://github.com/drduh/pwd.sh) for some ideas. Please check that project out as it might suit your needs better.

### Features
- [x] Search/Add/Update/Delete password entries
- [x] Generate random passwords
- [x] Manage additional custom fields other than just username/password
- [ ] Configurable symmetric/asymmetric encryption (asymmetric to work with OS Keychain program)
- [ ] Configure settings such as passbox file location from '.passboxrc' config file

### Pre-requisites
- GnuPG
- Grep
- Bash

### Installing
````
curl -L https://raw.githubusercontent.com/RobBollons/passbox/master/passbox > ./passbox && chmod +x ./passbox
````

### Usage
````
usage: passbox [action]

Passbox - command line password manager utility

ACTIONS
   add-field     <entry name>               Update an existing entry to add additional fields to
   delete        <entry name>               Remove an entry from the password database
   get           <entry name>               Get a particular password entry by it's name
   generate                                 Generate a new random password
   new                                      Prompt to create a new passbox entry
   remove-field  <entry name> <field name>  Update an existing entry to remove additional fields
   search        <search pattern>           Search the password database for a particular string, returns all matchin entries
   update        <entry name>               Update an existing entry in the password database
````

The default location of the passbox file is '~/passbox.gpg' however this can be overridden using the PASSBOX_LOCATION env variable. So for example you could put this in your .bashrc:
````
export PASSBOX_LOCATION='~/dropbox/passwords.gpg'
````

### Tests
Tests are ran locally against the 'test/' directory using [bats](https://github.com/sstephenson/bats) e.g. `bats test/`

**WARNING:** The tests will temporarily override the 'PASSBOX_LOCATION' env variable before each test but will restore it again after

### Similar Projects
[drudh/pwd.sh](https://github.com/drduh/pwd.sh) - Script to manage passwords in an encrypted file using gpg
[pass](http://www.passwordstore.org/) - Standard UNIX password manager
