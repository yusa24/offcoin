#!/bin/bash -e

############################################
# offcoin-offline.sh
############################################
# set up the offline ubuntu instance
############################################
# turn -x on if DEBUG is set to a non-empty string
# 'export DEBUG=1' to debug, 'export DEBUG=' to disable
[ -n "$DEBUG" ] && set -x
############################################

# Get script name and location for relative directory references
THIS_SCRIPT="$(basename $0)";
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/utils/globals.sh

## begin installation
e_header "offcoin-offline :: v$VERSION"
. $DIR/utils/offcoin-art.sh

# # ask for administrator password up front
# echo && e_arrow "You may be prompted for your admin password ..."
# sudo -v
#
# # update existing sudo time stamp until script finishes
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


e_header "Taking you off the grid, permanently."
if nmcli nm enable false 2> /dev/null; then
	e_success "Networking successfully disabled."
else
	e_error "Unable to disable networking."
	exit 1
fi

# Ensure offcoin is in $HOME before proceeding
e_header "Create offcoin in local directory"
if [[ ! -d $OFFCOIN_PATH ]]; then
	# ~/.offcoin doesn't exist? Copy it!
	e_arrow "Copying offcoin to $OFFCOIN_PATH"
	cp -r ../offcoin $OFFCOIN_PATH
	e_success "Finished copying."
else
	e_success "$OFFCOIN_PATH exists"
fi


# Move into copied offcoin path
cd $OFFCOIN_PATH


# grep for startup script in /etc/rc.local, append >> if absent
e_header "Setup startup.sh to run on boot"
STARTUPSCRIPT="sudo -u $(whoami) $OFFCOIN_PATH/scripts/startup.sh";
if grep -sq "$STARTUPSCRIPT" /etc/rc.local; then
	e_success "startup.sh previously installed."
else
	e_arrow "Appending startup.sh to /etc/rc.local"
	#find 'exit 0' and replace with call to startup script
	sudo sed -i 's/exit 0//g' /etc/rc.local
	echo "# $(date) -- $THIS_SCRIPT -- startup.sh installation
$STARTUPSCRIPT
exit 0" | sudo tee -a /etc/rc.local 1> /dev/null
	e_success "Modified /etc/rc.local to run startup.sh on boot"
fi

# grep for shutdown script in $ETC_RC_SHUTDOWN
e_header "Setup shutdown.sh to run on shutdown"
if [ ! -e $ETC_RC_SHUTDOWN ]; then
	e_arrow "Creating $ETC_RC_SHUTDOWN"
	echo "exit 0" | sudo tee -a $ETC_RC_SHUTDOWN 1> /dev/null
	e_success "$ETC_RC_SHUTDOWN created"
fi
SHUTDOWN_SCRIPT="sudo -u $(whoami) $OFFCOIN_PATH/scripts/shutdown.sh";
if grep -sq "$SHUTDOWN_SCRIPT" $ETC_RC_SHUTDOWN; then
	e_success "shutdown.sh previously installed in $ETC_RC_SHUTDOWN"
else
	e_arrow "Appending shutdown.sh to $ETC_RC_SHUTDOWN"
	#find 'exit 0' and replace with call to startup script
	sudo sed -i 's/exit 0//g' $ETC_RC_SHUTDOWN
	echo "# $(date) -- $THIS_SCRIPT -- shutdown.sh installation
$STARTUPSCRIPT
exit 0" | sudo tee -a $ETC_RC_SHUTDOWN 1> /dev/null
	e_success "Modified $ETC_RC_SHUTDOWN to run shutdown.sh on shutdown"
fi

# add shutdown.sh into $ETC_RC6_PATH
if [ -e $ETC_RC6_PATH/K99_shutdown.sh ]; then
	e_success "shutdown.sh previously installed in $ETC_RC6_PATH ($ETC_RC6_PATH/K99_shutdown.sh)"
else
	if [ ! -d $ETC_RC6_PATH ]; then
		e_error "$ETC_RC6_PATH does not exist"
		e_arrow "Creating $ETC_RC6_PATH"
		mkdir -p $ETC_RC6_PATH
		e_success "Created $ETC_RC6_PATH"
	fi
	e_arrow "Adding shutdown script to $ETC_RC6_PATH"
	cp $OFFCOIN_PATH/scripts/shutdown.sh $ETC_RC6_PATH/K99_shutdown.sh
	chmod +x $ETC_RC6_PATH/K99_shutdown.sh
	e_success "shutdown.sh added to $ETC_RC6_PATH"
fi


# Fix Mac keyboard mappings
e_header "Fixing \` & ~ key on Mac keyboard"
echo 'keycode 94 = grave asciitilde' > $UBUNTU_HOME_PATH/.Xmodmap
TILDEFIXCMD="xmodmap ~/.Xmodmap";
echo $TILDEFIXCMD > $UBUNTU_HOME_PATH/.xinitrc
e_arrow "Loading new xmodmap configuration"
xmodmap $UBUNTU_HOME_PATH/.Xmodmap
e_success "Loaded new xmodmap (fixed ~ and \` key)"


# TODO: Verify all packages again, truecrypt, armory/etc

# check if truecrypt installed
e_header "Install truecrypt"
if hash truecrypt 2> /dev/null; then
	e_success "truecrypt installed."
else
	e_arrow "Creating tmp directory for extracted files"
	mkdir -p $OFFCOIN_TOOLS_TMP
	e_arrow "Copying truecrypt tarball to tmp directory"
	cd $OFFCOIN_TOOLS
	cp $(ls truecrypt*) $OFFCOIN_TOOLS_TMP
	cd $OFFCOIN_TOOLS_TMP
	e_arrow "Extracting truecrypt tarball..."
	tar -xvf $(ls truecrypt*)
	e_arrow "Installing truecrypt..."
	./$(ls truecrypt*setup*)
	e_arrow "Cleaning up tmp directory for extracted files"
	cd $OFFCOIN_PATH
	rm -rf $OFFCOIN_TOOLS_TMP
	e_success "truecrypt installed."
fi

# check if armory installed
e_header "Install Armory"
if [ -e $ARMORY_PATH ]; then
	e_success "Armory installed."
else
	e_arrow "Creating tmp directory for extracted files"
	mkdir -p $OFFCOIN_TOOLS_TMP
	e_arrow "Copying Armory tarball to tmp directory"
	cd $OFFCOIN_TOOLS
	cp $(ls armory*) $OFFCOIN_TOOLS_TMP
	cd $OFFCOIN_TOOLS_TMP
	e_arrow "Extracting Armory tarball..."
	tar -xvf $(ls armory*)
	cd $(ls -d armory*)
	e_arrow "Installing Armory..."
	./$(*.sh)
	e_arrow "Cleaning up tmp directory for extracted files"
	cd $OFFCOIN_PATH
	rm -rf $OFFCOIN_TOOLS_TMP
	e_success "Armory installed."
fi


e_header "Bitcoin Home Directory"
e_arrow "Creating bitcoin directory ($OFFCOIN_BITCOIN)"
mkdir -p $OFFCOIN_BITCOIN
e_success "Created bitcoin directory"






# TODO: copy tools (e.g. vanitygen, bitaddress, etc.) here for user
# TODO: symlink shortcut to ~/bitcoin on desktop
# # https://en.bitcoin.it/wiki/Vanitygen






e_header "Initialize truecrypt bitcoin safe"
if [ -e $OFFCOIN_SAFE ]; then
	e_success "bitcoin safe already exists ($OFFCOIN_SAFE)"
else
	e_arrow "Initializing encrypted volume ($OFFCOIN_SAFE)..."
	truecrypt -t -v -c --volume-type=normal --size=$((1024*1024*1024)) --encryption=AES --hash=RIPEMD-160 --filesystem=FAT --random-source=/dev/urandom ~/bitcoin/bitcoin.safe
	if [ $? != 0 ]; then
		e_arrow "Error during truecrypt volume creation"
		exit 1
	fi
	e_success "Bitcoin safe created"
fi


e_header "Mount $OFFCOIN_SAFE"

e_arrow "Unmount anything on the target"
# TODO: Send output to /dev/null to keep output clean & '|| true' to ignore error
truecrypt -t -d $TRUECRYPT_MOUNT_POINT
truecrypt -t -d $OFFCOIN_SAFE

e_arrow "Mounting encrypted volume..."
truecrypt -t -v --mount $OFFCOIN_SAFE $TRUECRYPT_MOUNT_POINT
if [ $? != 0 ]; then
	e_error "Error during initial mount of encrypted volume."
	exit 1
fi

e_arrow "Unmounting encrypted volume..."
truecrypt -d $OFFCOIN_SAFE

e_header "Desktop shortcuts"
e_arrow "Link ~/bitcoin to Desktop"
ln -s $OFFCOIN_PATH $UBUNTU_HOME_PATH/Desktop/offcoin
e_success "Linked $UBUNTU_HOME_PATH/Desktop/offcoin"

e_arrow "Copying Armory shortcut to Desktop"
cp $OFFCOIN_PATH/utils/Armory.desktop $UBUNTU_HOME_PATH/Desktop/
sed -i "s#{{SCRIPT}}#$OFFCOIN_ARMORY_SCRIPT#g" $UBUNTU_HOME_PATH/Desktop/Armory.desktop
e_success "Linked $UBUNTU_HOME_PATH/Desktop/Armory.desktop"
