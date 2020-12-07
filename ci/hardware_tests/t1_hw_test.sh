#!/usr/bin/env bash

function finish {
  ./record_video.sh ${CI_COMMIT_SHORT_SHA} stop
  ls -l *.mp4
}
trap finish EXIT

set -e # exit on nonzero exitcode
set -x # trace commands


./record_video.sh ${CI_COMMIT_SHORT_SHA} start
(cd ../.. && poetry install)
#poetry run trezorctl -v list
#export TREZOR_PATH=$(./get_trezor_path.sh 'Trezor 1')
#echo $TREZOR_PATH

uhubctl -l 3-1.4 -p 4 -a off
sleep 5
uhubctl -l 3-1.4 -p 4 -a on
sleep 5

poetry run python bootstrap.py t1
poetry run python bootstrap.py t1 ../../trezor-*.bin
poetry run trezorctl list -n
poetry run timeout 2h pytest -x ../../tests/device_tests
