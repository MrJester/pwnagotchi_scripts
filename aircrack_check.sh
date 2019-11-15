#!/usr/bin/env bash

BAD_CAP_DIR="/root/handshakes/bad_cap"
COUNT=0
BAD_COUNT=0
GOOD_COUNT=0

if [ -f /usr/bin/aircrack-ng ]; then
	echo "[+] Aircrack-ng FOUND"

else
	echo "[!] Aircrack-ng NOT FOUND"
	echo "[!] Install aircrack-ng with: sudo apt install -y aircrack-ng"
	exit
fi

mkdir -p $BAD_CAP_DIR

for i in `ls /root/handshakes/*.pcap`; do
	FILE=$(basename $i)

	if [[ ! $(echo q| /usr/bin/aircrack-ng $i 2> /dev/null| grep -E "[1-9][0-9]?[0-9]? handshake|PMKID"| awk '{print $2}') ]]; then
		echo "[-] Bad Capture file FOUND moving: ${FILE}"
		cp -ar $i $BAD_CAP_DIR/$FILE
		rm -rf $i
		BAD_COUNT=$((BAD_COUNT+1))
	else
		echo "[+] ${FILE} is a proper capture"
		GOOD_COUNT=$((GOOD_COUNT+1))
	fi

	COUNT=$((COUNT+1))
done

echo "[+] Finished processing capture files"
echo "[+] Processed ${COUNT} captures files"
echo "[+] ${BAD_COUNT} were not complete capture files"
echo "[+] ${GOOD_COUNT} are complete capture files"
