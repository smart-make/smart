# -*- shell-script -*-
#
#  Copyright (C) 2013, by Duzy Chan <code@duzy.info>
#
#  All rights reserved.
#
readonly location=$(dirname $0)
readonly applet=$(basename $0)

function run-applet ()
{
    local script=$location/applets/$applet.bash

    . $location/source/debug.bash
    . $location/source/utils.bash

    if [[ -f $script ]]; then
	. $script && main $@
    else
	error "No applet $applet!"
    fi
}

run-applet $@
