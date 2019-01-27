#!/bin/sh

# Lists key at the top of your keychain
# OR A key you specify
gpg -k --fingerprint $1 |head -n 4 |tail -n 1 |sed 's/ //g'|cut -c 25-
