#!/bin/sh

export CURRLOC=$(pwd)
source ${CURRLOC}/functions.sh
source ${CURRLOC}/manual.sh

f_rc test 100 -eq 100
