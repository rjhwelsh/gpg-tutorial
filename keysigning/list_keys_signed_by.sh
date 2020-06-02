#!/bin/sh

keyid=`./list_key.sh $1`

private_keys=`gpg --with-colons -K|grep fpr|cut -d':' -f10`

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
	  # Exclude private keys from consideration
	  echo "${private_keys}"|\
	      grep "${fingerprint}" >/dev/null ||
              echo "${fingerprint}"
      fi
      ;;
  esac
done |
uniq
