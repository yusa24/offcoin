#!/bin/bash -e

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/../utils/globals.sh

# modify /boot/grub/grub.cfg, etc.
e_header "Adjusting grub boot options..."
