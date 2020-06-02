#!/bin/sh

keyid=`./list_key.sh $1`

gpg --with-colons --fingerprint --list-sigs |
while read line; do
  packettype="$(echo "${line}" | cut -d':' -f1)"
  case $packettype in
    fpr)
      fingerprint="$(echo "${line}" | cut -d':' -f10)"
      ;;
    sig)
      issuedby="$(echo "${line}" | cut -d':' -f5)"
      if [ "x${issuedby}" = "x${keyid}" ]; then
        echo "${fingerprint}"
      fi
      ;;
  esac
done |
uniq
