#!/bin/bash -e
# record analytics

#set -x

# Get script location for relative directory references
DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"

# Import global variables and functions
. $DIR/globals.sh


INFO="$(curl -sS ipinfo.io)"

CREATE_INSTALLLOCATION="$(curl -sS -X POST \
  -H "X-Parse-Application-Id: Hqc2lXaNmFDr9u2pfy3Qh6KBzogDSQ0BVxfdjqco" \
  -H "X-Parse-REST-API-Key: JeZvqEepLAkpFbl3diBT9QqBJG7IUQdejJX6liyF" \
  -H "Content-Type: application/json" \
  -d "{
    \"city\":\"$(GetJSONValue "$INFO" "city")\",
    \"region\":\"$(GetJSONValue "$INFO" "region")\",
    \"country\":\"$(GetJSONValue "$INFO" "country")\"
  }" \
  https://api.parse.com/1/classes/InstallLocation/ )";
