#!/bin/sh

set -e

if [ "$1" = 'start' ]; then
	mix run --no-halt
fi

exec "$@"
