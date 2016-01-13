#!/bin/sh
# KerioMailboxArchiver.sh v1.0.0
if [ `whoami` != "root" ] ; then 
	echo "Script failed. Enter sudo -s and try again"
	exit 1
fi

if [ "$1" == "" ] || [ "$1" == "help" ] ; then
	echo "Pass full path of mailbox, for example:"
	echo "/usr/local/kerio/mailserver/store/mail/domain.com/user/INBOX"
	echo "This script will file the messages into sub-folders by years"
	exit 1
fi

echo "This script will file the messages into sub-folders by years"

MAILBOX="$1"
curYear=`date +"%Y"`

function MakeSubMailbox() {
	local theYear=$1
	SubMailbox="$MAILBOX/$theYear"
	if [ ! -d "$SubMailbox" ]; then
		echo "Creating $SubMailbox"
		mkdir "$SubMailbox"
		mkdir "$SubMailbox/#msgs"
		mkdir "$SubMailbox/#assoc"
		touch "$SubMailbox/index.fld" "$SubMailbox/properties.fld" 
		echo "T0" > "$SubMailbox/status.fld" 
	fi
}

cd "$MAILBOX/#msgs"

for theMsg in *.eml ; do
	if [ "$theMsg" != "" ] ; then
		msgYear=`stat -f "%Sm" $theMsg | awk '{print $NF}'`
		if [ "$msgYear" != "$curYear" ] ; then
			MakeSubMailbox "$msgYear"
			mv "$MAILBOX/#msgs/$theMsg" "$MAILBOX/$msgYear/#msgs/"
		fi
	fi
done

echo ""
echo "IMPORTANT: When the script completes, go to Kerio admin and"
echo "RESTART the Kerio Connect server, unfortunately a live re-index of the "
echo "user mailbox will not find all the new folders"
