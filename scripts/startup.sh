#!/bin/bash

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables
. $DIR/../utils/global-variables.sh

# Disable networking
nmcli nm enable false 2> /dev/null

# Removing Install Ubuntu command from desktop
if [ -e $UBUNTU_HOME_PATH/Desktop/ubiquity-gtkui.desktop ]; then
	rm $UBUNTU_HOME_PATH/Desktop/ubiquity-gtkui.desktop
fi

# Write run time
mkdir -p $OFFCOIN_LOGS
echo $(date) > $OFFCOIN_LOGS/lastruntime