#!/bin/bash

echo "Taking you off the grid..."
if nmcli nm enable false 2> /dev/null; then
	echo "Networking successfully disabled."
else
	echo "Networked already disabled."
fi


STARTUPSCRIPT="sudo -u $(whoami) $HOME/startup/startup.sh";
# copy startup.sh to local startup dir
if mkdir -p ~/startup && cp startup.sh ~/startup && chmod +x ~/startup/startup.sh; then
	echo "startup.sh copied to local startup directory"
else
	echo "Error copying startup.sh to local startup directory"
	exit 1
fi

# grep for startup script in rc.local, append >> if absent
if grep -sq "$STARTUPSCRIPT" /etc/rc.local; then
	echo "startup.sh previously installed."
else
	echo "Appending startup.sh to /etc/rc.local to run on boot..."
	# find 'exit 0' and replace with call to startup script
	sudo sed -i 's/exit 0//g' /etc/rc.local
	echo "# $(date) -- setup-offline.sh -- startup.sh installation
$STARTUPSCRIPT
exit 0" | sudo tee -a /etc/rc.local 1> /dev/null
fi

# Fix Mac keyboard mappings
echo "Fixing tilde key on Mac keyboard..."
echo 'keycode 94 = grave asciitilde' > $HOME/.Xmodmap
TILDEFIXCMD="xmodmap ~/.Xmodmap";
echo $TILDEFIXCMD > $HOME/.xinitrc
xmodmap ~/.Xmodmap

# verify all packages again, truecrypt, armory/etc
# copy to home directory and extract/install

# check if truecrypt installed
if hash truecrypt 2> /dev/null; then
	echo "Truecrypt installed."
else
	echo "Installing truecrypt..."
	#cd ~/bitcoin
	#tar -xvf $(ls truecrypt*)
	#./$(ls truecrypt*setup*)
fi

ARMORYCLIENTPATH="/usr/lib/armory/ArmoryQt.py";
ARMORYCLIENT="python $ARMORYCLIENTPATH --offline";

# check if armory installed
if [ -e $ARMORYCLIENTPATH ]; then
	echo "Armory installed."
else
	echo "Installing armory..."
	#cd ~/bitcoin
	#tar -xvf $(ls armory*)
	#cd $(ls -d armory*)
	#./$(*.sh)
fi

if [ -e ~/bitcoin/bitcoin.safe ]; then
	echo "bitcoin.safe already exists."
else
	echo "Initializing encrypted volume (~/bitcoin/bitcoin.safe)..."
	truecrypt -t -v -c --volume-type=normal --size=$((1024*1024*1024)) --encryption=AES --hash=RIPEMD-160 --filesystem=FAT --random-source=/dev/urandom ~/bitcoin/bitcoin.safe
	if [ $? != 0 ]; then
		echo "Error during truecrypt volume creation."
		exit 1
	fi
fi

#unmount anything on the target
#send output to /dev/null to keep output clean
truecrypt -t -d /media/truecrypt-bitcoin-safe
truecrypt -t -d ~/bitcoin/bitcoin.safe

echo "Mounting encrypted volume..."
truecrypt -t -v --mount ~/bitcoin/bitcoin.safe /media/truecrypt-bitcoin-safe
if [ $? != 0 ]; then
	echo "Error during initial mount of encrypted volume."
	exit 1
fi


#create armory startup icon on desktop with armory.sh command

#call armory.sh script
#mounts encrypted volume & starts offline armory with datadir 

#start armory client offline mode, datadir encrypted volume
$ARMORYCLIENT --datadir=/media/truecrypt-bitcoin-safe


#echo "Unmounting encrypted volume..."
#truecrypt -d ~/bitcoin/bitcoin.safe


