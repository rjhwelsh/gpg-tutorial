#!/bin/sh

# Lists key at the bottom of your keychain (latest?)
# OR A key you specify

# Returns keyid in 'long' format

gpg -k $1 |\
    grep -Po '[0-9ABCDEF]{40}' |\
    tail -n 1|\
    cut -c 25-40
