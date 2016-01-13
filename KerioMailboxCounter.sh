#!/bin/sh
# KerioMailboxCounter.sh
if [ `whoami` != "root" ] ; then 
	echo "Script failed. Enter sudo -s and try again"
	exit 1
fi
if [ "$1" == "" ] ; then
	echo "Pass full path of kerio domain, for example:"
	echo "/usr/local/kerio/mailserver/store/mail/domain.com"
	echo "This script will scan a domain and list "
	echo "the number of messages in INBOX and SENT ITEMS"
	exit 1
fi

domain=$1

cd "$domain"

for account in * ; do
	if [ "$account" != "#public" ] ; then
		echo "$account"
		printf "Inbox:      "
		test -d "$account/INBOX/" && ls -1 "$domain/$account/INBOX/#msgs" | wc -l || echo ""
		printf "Sent Items: "
		test -d "$account/Sent Items/" && ls -1 "$domain/$account/Sent Items/#msgs" | wc -l  || echo ""
		echo "--------------------"
	fi
done
