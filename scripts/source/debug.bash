#
#  Copyright (C) 2013, by Duzy Chan <code@duzy.info>
#  
#  All rights reserved.
#
shopt -s extglob

function debug ()
{
    local n=0
    for a in "$@"; do
	case $a in
	    -+([0-9]))
		n="${a:1}"
		shift
		;;
	esac
    done

    local source=${BASH_SOURCE[$(($n+1))]}
    local funcname=${FUNCNAME[$(($n+1))]}
    local lineno=${BASH_LINENO[$n]}
    echo "$source:$lineno:debug: $funcname: $@" > /dev/stderr
}

function error ()
{
    local n=0
    for a in "$@"; do
	case $a in
	    -+([0-9]))
		n="${a:1}"
		shift
		;;
	esac
    done

    local source=${BASH_SOURCE[$(($n+1))]}
    local funcname=${FUNCNAME[$(($n+1))]}
    local lineno=${BASH_LINENO[$n]}
    echo "$source:$lineno:error: $@ ($funcname)" > /dev/stderr
    exit $lineno
}

function info ()
{
    local n=0
    for a in "$@"; do
	case $a in
	    -+([0-9]))
		n="${a:1}"
		shift
		;;
	esac
    done

    local source=${BASH_SOURCE[$(($n+1))]}
    local funcname=${FUNCNAME[$(($n+1))]}
    local lineno=${BASH_LINENO[$n]}
    echo "$source:$lineno:info: $@"
}

function todo ()
{
    local n=0
    for a in "$@"; do
	case $a in
	    -+([0-9]))
		n="${a:1}"
		shift
		;;
	esac
    done

    local source=${BASH_SOURCE[$(($n+1))]}
    local funcname=${FUNCNAME[$(($n+1))]}
    local lineno=${BASH_LINENO[$n]}
    echo "$source:$lineno:todo: $@ ($funcname)"
}
