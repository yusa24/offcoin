#!/bin/bash -e


# Variables
####################

VERSION="0.1";

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
ARMORY_CLIENT="python $ARMORY_PATH --offline";
OFFCOIN_ARMORY_SCRIPT="$OFFCOIN_PATH/scripts/armory.sh";

# Bitcoin Safe
OFFCOIN_SAFE="$OFFCOIN_BITCOIN/bitcoin.safe"

# Truecrypt
TRUECRYPT_MOUNT_POINT="/media/truecrypt-bitcoin-safe";


# Functions
####################

# Console output
function e_header()   { echo -e "\033[1;35m☆\033[0m  $@"; };
function e_success()  { echo -e "  \033[1;32m ✔\033[0m  $@"; };
function e_error()    { echo -e "  \033[1;31m ✖\033[0m  $@"; };
function e_arrow()    { echo -e "  \033[1;33m ➜\033[0m  $@"; };

function GetToolPath()
{
  # $1 : name of tool, e.g. armory, truecrypt, etc.
  # Output path to matching file (starting with tool name)
  echo $(ls $OFFCOIN_TOOLS/$1*)
}

function VerifyHash()
{

  # $1 : name of tool to calculate hash
  # $2 : name of hash algorithm
  # $3 : url to endpoint containing hash values

  case $2 in
  sha1)
    hashcmd="openssl sha1"
    hashregex="[a-zA-Z0-9]{40}";
    ;;
  sha256)
    hashcmd="shasum -a 256";
    hashregex="[a-zA-Z0-9]{64}";
    ;;
  md5)
    hashcmd="md5";
    hashregex="[a-zA-Z0-9]{32}";
    ;;
  *)
    hashcmd=-1;
    ;;
  esac

  if [[ $hashcmd == "-1" ]]; then
    echo "Unable to find hash type ($1)";
    exit 1;
  else
    # Get path to tool
    toolpath="$(GetToolPath $1)";

    # Use hashregex to parse hash out from command
    hashresult="$($hashcmd $toolpath)";
    calchash=$(echo $hashresult | egrep -io $hashregex);

    # Get hash from external source
    sitehash="$(curl $3 | grep -i "$(basename $toolpath)" | egrep -io "$hashregex")";

    # Verify hash
    [[ $calchash == $sitehash ]] && echo 0 || echo 1

  fi
}
