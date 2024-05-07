#!/usr/bin/env sh

set -eu

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run as root!' >&2
    exit 1
fi

if ! [ -x "$(command -v cabextract)" ]; then
    echo 'This script requires cabextract!' >&2
    exit 1
fi

if [ "${1:-}" != --skip-disclaimer ]; then
    echo "The firmware for the wireless dongle is subject to Microsoft's Terms of Use:"
    echo 'https://www.microsoft.com/en-us/legal/terms-of-use'
    echo
    echo 'Press enter to continue!'
    read -r _
fi

firmware_hash='48084d9fa53b9bb04358f3bb127b7495dc8f7bb0b3ca1437bd24ef2b6eabdf66'

cabextract -F FW_ACC_00U.bin driver.cab
echo "$firmware_hash" FW_ACC_00U.bin | sha256sum -c
mv FW_ACC_00U.bin /lib/firmware/xow_dongle.bin

