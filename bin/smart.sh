#!/usr/bin/env bash
SMARTROOT=$(dirname $(dirname $0))
GNUMAKE=$(which make)
exec $GNUMAKE -f $SMARTROOT/load.mk $@
