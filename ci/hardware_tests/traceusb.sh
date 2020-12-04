#!/usr/bin/env bash

set -ex

if [ $# -ne 1 ]
  then
    echo "Usage: $0 /dev/bus/usb/00N"
fi

echo ""
date
ps auxf
uhubctl
echo ""

exit 0
