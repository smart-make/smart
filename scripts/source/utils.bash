#
#  Copyright (C) 2013, by Duzy Chan <code@duzy.info>
#  
#  All rights reserved.
#
function for-each ()
{
    local action=$1
    for name in *; do
	$action "$name"
    done
}

function for-each-directory ()
{
    local action=$1
    for name in *; do
	if [[ -d $name ]]; then
	    $action "$name"
	fi
    done
}

function for-each-file ()
{
    local action=$1
    for name in *; do
	if [[ -f $name ]]; then
	    $action "$name"
	fi
    done
}
