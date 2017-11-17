#!/bin/bash
# You will need to have bash and GNUPG installed for this.

function intro {
	echo "Create your own gpg key!"
	echo "A how-to bashscript by Roger Welsh"
	echo ""
	echo "pass-gen - Step 1 PASSWORD GENERATION EXAMPLE"
	echo "key-gen  - Step 2 PRIVATE KEY GENERATION (using GNUPG)"
	echo "upload-own-key - Step 3 UPLOAD PUBLIC KEY TO KEYSERVER"
	echo "web-of-trust   - Step 4 DOWNLOAD AND SIGN MY PUBLIC KEY"
	echo "verify-this-script - Step 5 VERIFY I WROTE THIS"
	echo "overwrite-signature - Step 6 - SIGN THIS SCRIPT"
	echo ""
	echo "Type any chars or CTRL-D to exit"
	echo "Use CTRL-C to cancel any operation."
	sleep 1 && echo ""
}

# Password word selection
# This will generate 4 random words from a 470,000 word, wordlist.
function pass-gen {
	echo "Step 1 - PASSWORD GENERATION"
	echo "Please type in the path of a wordlist file, preferably with 470k words."
	read -e WORDLIST
	echo "As an example, ;) , you could use these words for your passphrase."
	echo ""
	FACTOR=$[ 2**(4*8)/$(cat "$WORDLIST"|wc -l) ]
	cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / $FACTOR ]" | tail -1
	cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / $FACTOR ]" | tail -1
	cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / $FACTOR ]" | tail -1
	cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / $FACTOR ]" | tail -1
	cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / $FACTOR ]" | tail -1
	echo ""
	echo "Each word is generated with ..."
	echo 'example@bash$ cat "$WORDLIST" | head -n "$[ $(od -vAn -N4 -tu4 < /dev/random ) / 9138 ]" | tail -1'
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	clear
}

function key-gen {
	echo "Step 2 - KEY GENERATION"
	sleep 1
	echo "Please use your real/relevant details, this key is to PROVE your identity."
	echo "Typically the cryptography is unbreakable ( use rsa-2048, not rsa-1024), only passwords, people and endpoints are weak."
	echo "PRESS ENTER TO RUN GPG>"
	echo "example@bash$ gpg --gen-key"
	read -e blank
	gpg --gen-key
	sleep 1 && echo ""
}

function upload-own-key {
	echo "Step 3 - UPLOAD TO KEYSERVER"
	echo "example@bash$ gpg --list-keys"
	gpg --list-keys
	sleep 1 && echo ""
	echo "YOUR FINGERPRINT IS LISTED ABOVE. PLEASE TYPE THE LAST 8 CHARS OF IT BELOW."
	read -p "FINGERPRINT>" -e $FINGERPRINT
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "Uploading key to keyserver."
	echo "example@bash$ gpg --send-keys $FINGERPRINT"
	gpg --send-keys "$FINGERPRINT"
	sleep 1 && echo ""

	}

function web-of-trust {
	echo "Step 4 - THE WEB OF TRUST"
	echo "Download my public key!"
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "example@bash$ gpg --recv-keys 553A180D"
	gpg --recv-keys 553A180D
	sleep 1 && echo ""

	echo "Verify my (roger@protonmail.ch) public key fingerprint matches."
	echo "My fingerprint is: 2FCB9E31EA77CDECA3AE5DD7D54CC777553A180D"
	echo "Check below."
	echo "example@bash$ gpg --list-public-keys 553A180D "
	gpg -k 553A180D
	sleep 1 && echo ""

	echo "Sign my key with yours."
	echo "Use whatever trust level you feel applies, (only use ultimate if you ARE me)."
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "example@bash$ gpg --sign-key 553A180D"
	gpg --sign-key 553A180D
	sleep 1 && echo ""

	echo "Upload my signed key back to the pgp server"
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "example@bash$ gpg --send-keys 553A180D"
	gpg --send-keys 553A180D
	sleep 1 && echo ""

	}

function verify-this-script {
	echo "Step 5 - VERIFICATION I WROTE THIS"
	echo "(and that the words are all good.)"
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "example@bash$ gpg --verify $0.sig $0"
	gpg --verify "$0.sig" "$0"
	gpg --verify "words.txt.sig" "words.txt"
	sleep 1 && echo ""
}

function overwrite-signature {
	echo "Step 6 - SIGN THIS SCRIPT"
	echo "( After signing with your own signature, the signature will bear your NAME instead of mine. :)"
	echo "( Select y to overwrite.)"
	echo "PRESS ENTER TO CONTINUE>" && read -e blank
	echo "example@bash$ gpg --detach-sign $0"
	gpg --detach-sign "$0"
	gpg -b "words.txt"
	sleep 1 && echo ""
}


function more-info {
	echo "For encryption and decryption you can use:"
	sleep 1 
	echo "example@bash$ gpg --encrypt FILE"
	sleep 2 
	echo "example@bash$ gpg --decrypt FILE "
	sleep 3 
	echo "Respectively. See man gpg for more info."
	sleep 4 && echo ""
	echo "For a comprehensive overview and the security conscious (you should be),"
	echo "please see https://www.gnupg.org/gph/en/manual.html"
	sleep 4 && echo ""
	echo "Thankyou for your using my tutorial script."
	echo "I hope you enjoyed it. :) "
	sleep 4 && echo ""
	echo "TOGETHER"
	sleep 4 && echo ""
	echo "Let's encrypt."
}
# Main
intro 

select WORD in all intro pass-gen key-gen upload-own-key web-of-trust \
		verify-this-script overwrite-signature \
		all-gpg-commands more-info exit

	do case $WORD in
		all) pass-gen && key-gen && upload-own-key && web-of-trust && verify-this-script && overwrite-signature && verify-this-script && more-info ;;
		intro) intro;;
		pass-gen) pass-gen;;
		key-gen)key-gen;;
		upload-own-key)upload-own-key;;
		web-of-trust)web-of-trust;;
		verify-this-script) verify-this-script;;
		overwrite-signature)overwrite-signature;;
		all-gpg-commands) head -n 122 $0  | grep gpg | grep -v echo;;
		more-info) more-info ;;
		exit)exit;;
		*)exit;;
	esac
done

	


