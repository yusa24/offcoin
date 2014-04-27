#!/bin/bash -e

VERSION="0.1";

function e_header()   { echo -e "\033[1;35m☆\033[0m  $@"; };
function e_success()  { echo -e "  \033[1;32m ✔\033[0m  $@"; };
function e_error()    { echo -e "  \033[1;31m ✖\033[0m  $@"; };
function e_arrow()    { echo -e "  \033[1;33m ➜\033[0m  $@"; };


# osx testing
OFFCOIN_DIR=".offcointest";

# Ubuntu
UBUNTU_HOME_PATH="$HOME";
ETC_RC6_PATH="/etc/rc6.d";
ETC_RC_SHUTDOWN="/etc/rc.local.shutdown";

# offcoin
# OFFCOIN_DIR=".offcoin";
OFFCOIN_PATH="$UBUNTU_HOME_PATH/$OFFCOIN_DIR";
OFFCOIN_LOGS="$OFFCOIN_PATH/logs";
OFFCOIN_TOOLS="$OFFCOIN_PATH/tools";
OFFCOIN_BITCOIN="$OFFCOIN_PATH/bitcoin";

# Tools (install)
OFFCOIN_TOOLS_TMP="$OFFCOIN_TOOLS/tmp";

# Armory
ARMORY_PATH="/usr/lib/armory/ArmoryQt.py";
ARMORY_CLIENT="python $ARMORYCLIENT_PATH --offline";

# Bitcoin Safe
OFFCOIN_SAFE="$OFFCOIN_BITCOIN/bitcoin.safe"

# Truecrypt
TRUECRYPT_MOUNT_POINT="/media/truecrypt-bitcoin-safe";
