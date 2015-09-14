#!/bin/bash
set -ex

wget -O bats-v0.4.0.tar.gz https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz
tar -zxvf bats-v0.4.0.tar.gz
cd bats-0.4.0
mkdir ~/env
./install.sh ~/env

if [ "${TRAVIS_OS_NAME}" == 'osx' ]; then
    brew update
    brew install gnupg
fi
