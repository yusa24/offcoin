#!/bin/bash -e
# record analytics

#set -x

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/globals.sh


INFO="$(curl ipinfo.io)"

GetJSONValue "$INFO" "city"
GetJSONValue "$INFO" "region"
GetJSONValue "$INFO" "country"
GetJSONValue "$INFO" "postal"
