#!/bin/bash

VERSION="0.1";

function e_header()   { echo -e "\033[1;35m☆\033[0m  $@"; };
function e_success()  { echo -e "  \033[1;32m ✔\033[0m  $@"; };
function e_error()    { echo -e "  \033[1;31m ✖\033[0m  $@"; };
function e_arrow()    { echo -e "  \033[1;33m ➜\033[0m  $@"; };


# osx testing
UBUNTU_HOME_PATH="/Users/noah";
OFFCOIN_DIR=".offcointest";

# UBUNTU_HOME_PATH="/home/ubuntu";

# OFFCOIN_DIR=".offcoin";
OFFCOIN_PATH="$UBUNTU_HOME_PATH/$OFFCOIN_DIR";
OFFCOIN_LOGS="$OFFCOIN_PATH/logs";
