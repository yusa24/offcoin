#!/bin/bash -e

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/../utils/globals.sh

e_header "Armory with truecrypt datadir"
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

e_arrow "Opening Armory with mounted truecrypt volume..."
# mounts encrypted volume & starts offline armory with datadir
# start armory client offline mode, datadir encrypted volume
$ARMORY_CLIENT --datadir=$TRUECRYPT_MOUNT_POINT

e_success "Armory initialized"

exit 0
