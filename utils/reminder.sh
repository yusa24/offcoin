#!/bin/bash -e
# This file is sourced at the end of an offcoin install

cat <<EOF


offcoin expects a few components in the tools/ directory in
order to setup the bootable Ubuntu flash drive...
  1. syslinux zip
  2. unetbootin zip

In order to setup the offline instance of Ubuntu we will also
need the following components present as well...
  1. armory deb
  2. truecrypt tarball

While this script does attempt to verify the various components
there is no guarantee and you are strongly encouraged to gather
these files manually and place them in the tools/ directory.



EOF
