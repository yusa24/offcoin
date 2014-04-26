#!/bin/bash

# offcoin.sh
# set up the offline ubuntu instance and some dependencies

VERSION="0.1";

function e_header()   { echo -e "\033[1;35m☆\033[0m  $@"; };
function e_success()  { echo -e "  \033[1;32m ✔\033[0m  $@"; };
function e_error()    { echo -e "  \033[1;31m ✖\033[0m  $@"; };
function e_arrow()    { echo -e "  \033[1;33m ➜\033[0m  $@"; };

## begin installation
e_header "offcoin :: v$VERSION"

# # ask for administrator password up front
# echo && e_arrow "You may be prompted for your admin password ..."
# sudo -v
#
# # update existing sudo time stamp until script finishes
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# If git isn't installed, just keep going without updating...
if [[ ! -e "$(which git)" ]]; then
  e_error "git is not installed. Attempting to continue with current version..."
fi

# Initialize.
OFFCOIN_PATH="$HOME/.offcoin";
if [[ ! -d $OFFCOIN_PATH ]]; then
  new_offcoin_install=1
  # ~/.offcoin doesn't exist? Clone it!
  e_header "Downloading offcoin to $OFFCOIN_PATH"
  git clone --recursive git://github.com/magus/offcoin.git $OFFCOIN_PATH
  cd $OFFCOIN_PATH
else
  # Make sure we have the latest files
  e_header "Updating existing offcoin ($OFFCOIN_PATH)"
  cd $OFFCOIN_PATH
  git pull
  git submodule update --init --recursive --quiet
fi



#do the heavy lifting, copy dem weights




# Lest we forget to do a few additional things...
if [[ "$new_offcoin_install" && -e "conf/firsttime_reminder.sh" ]]; then
  e_header "First-Time Reminders"
  bash -c 'source conf/firsttime_reminder.sh'
fi

# All done!
e_header "All done!"
