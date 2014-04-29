#!/bin/bash -e

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/../utils/globals.sh


tool="armory";
e_header "Verify $tool"
hashurl="https://s3.amazonaws.com/bitcoinarmory-media/armory_0.91-beta_sha256.txt.asc";
if [ $(VerifyHash $tool sha256 $hashurl) ]; then
  e_success 'Hashes match'
else
  e_error 'Hashes do not match'
fi

tool="syslinux";
e_header "Verify $tool"
hashurl="https://www.kernel.org/pub/linux/utils/boot/syslinux/sha256sums.asc";
if [ $(VerifyHash $tool sha256 $hashurl) ]; then
  e_success 'Hashes match'
else
  e_error 'Hashes do not match'
fi
