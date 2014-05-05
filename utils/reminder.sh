#!/bin/bash -e
# This file is sourced at the end of an offcoin install

cat <<EOF


offcoin expects a few components in the tools/ directory in
order to setup the bootable Ubuntu flash drive on Mac OSX...
  1. syslinux zip
        http://www.syslinux.org/wiki/index.php/The_Syslinux_Project
  2. unetbootin zip
        http://unetbootin.sourceforge.net/

In order to setup the offline instance of Ubuntu we will also
need the following Ubuntu components present as well...
  1. armory deb
        https://bitcoinarmory.com/download/
  2. truecrypt tarball
        http://www.truecrypt.org/

While this script does attempt to verify the various components
there is no guarantee and you are strongly encouraged to gather
these files manually and place them in the tools/ directory.


EOF
