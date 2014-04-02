#!/bin/bash

# Disable networking
nmcli nm enable false 2> /dev/null

# Removing Install Ubuntu command from desktop
if [ -e /home/ubuntu/Desktop/ubiquity-gtkui.desktop ]; then
	rm /home/ubuntu/Desktop/ubiquity-gtkui.desktop
fi

# Write run time
echo $(date) > /home/ubuntu/startup/lastruntime
