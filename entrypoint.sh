#!/usr/bin/env bash

export PATH=${PATH:+${PATH}:}/img/opt/tests
export PYTHONPATH=${PYTHONPATH:+${PYTHONPATH}:}/img/opt/tests
exec "$@"
