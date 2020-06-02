#!/bin/sh

# Lists key at the bottom of your keychain (latest?)
# OR A key you specify
gpg -k $1 |grep -Po '[0-9ABCDEF]{40}' |tail -n 1
