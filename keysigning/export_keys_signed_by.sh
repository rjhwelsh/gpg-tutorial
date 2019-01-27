#!/bin/bash

your_key=`./list_key.sh $1`
your_name=`./list_name.sh $1 2>/dev/null`

for their_key in $(./list_keys_signed_by.sh $1 );
do
	their_email=`gpg --with-colons --list-key $their_key |\
		grep '@' |\
		./extract_emails.pl 2>/dev/null |\
		head -n 1;`
	thier_name=`./list_name.sh $their_key 2>/dev/null`

	echo "Exporting key for.."
	echo "EMAIL:"$their_email
	echo "FPR:"$their_key

	# If there is no email skip...
	if [[ -z $their_email ]]; then
		continue
	fi

	# Create directories for each email id
	mkdir -vp signed_keys/$their_email

	# Export signed keys for each id
	gpg --export --armor $their_key |\
		gpg --encrypt --sign --armor -u $your_key -r $your_key -r $their_key > signed_keys/$their_email/signed_key.asc

	# Create msg for each key
	echo "Hi$their_name,
Please find attached the signed key for $their_email
of your key $their_key signed by me.

You can import this key by running:
    gpg -d signed_key.asc | gpg --import

I have not uploaded your key to any keyservers.
If you would like this new signature to be available to others,
please upload it yourself.

For example:
    gpg --keyserver hkp://pool.sks-keyservers.net --send-key $their_key

If you have any questions, don't hesistate to ask.

Regards,
--
$your_name
 0x$your_key
" | gpg --encrypt --sign --armor -u $your_key -r $your_key -r $their_key > signed_keys/$their_email/msg.asc

done
