#!/usr/bin/env bash

function finish {
  nix-shell --run "./record_video.sh ${CI_COMMIT_SHORT_SHA} stop"
  ls -l *.mp4
}
trap finish EXIT

set -e # exit on nonzero exitcode
set -x # trace commands


mkdir out
./traceusb.sh /dev/bus/usb/003 &>> out/traceusb.txt
lsof -t +d /dev/bus/usb/003 | xargs kill || true
./record_video.sh ${CI_COMMIT_SHORT_SHA} start
(cd ../.. && poetry install)
#poetry run trezorctl -v list
#export TREZOR_PATH=$(./get_trezor_path.sh 'Trezor 1')
#echo $TREZOR_PATH
poetry run trezorctl list -n
poetry run python bootstrap.py t1
poetry run python bootstrap.py t1 ../../trezor-*.bin
poetry run trezorctl list -n
poetry run timeout 2h pytest -x ../../tests/device_tests -k test_ping
./traceusb.sh /dev/bus/usb/003 &>> out/traceusb.txt
