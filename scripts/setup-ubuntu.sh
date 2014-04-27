#!/bin/bash -e

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables
. $DIR/../utils/global-variables.sh

# modify /boot/grub/grub.cfg, etc.
e_header "Adjusting grub boot options..."
