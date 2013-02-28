#
#  Copyright (C), by Duzy Chan <code@duzy.info>, 2013
#  All rights reserved.
#
function debug ()
{
    local source=${BASH_SOURCE[1]}
    local funcname=${FUNCNAME[1]}
    local lineno=${BASH_LINENO[0]}
    #if (($lineno <= 0)); then lineno=${BASH_LINENO[0]}; fi
    echo "$source:$lineno:debug: $funcname: $@"
}

function error ()
{
    local source=${BASH_SOURCE[1]}
    local funcname=${FUNCNAME[1]}
    local lineno=${BASH_LINENO[0]}
    #if (($lineno <= 0)); then lineno=${BASH_LINENO[0]}; fi
    echo "$source:$lineno:error: $@ ($funcname)"
    exit $lineno
}

function info ()
{
    local source=${BASH_SOURCE[1]}
    local funcname=${FUNCNAME[1]}
    local lineno=${BASH_LINENO[0]}
    #if (($lineno <= 0)); then lineno=${BASH_LINENO[0]}; fi
    echo "$source:$lineno:info: $@"
}

function todo ()
{
    local source=${BASH_SOURCE[1]}
    local funcname=${FUNCNAME[1]}
    local lineno=${BASH_LINENO[0]}
    #if (($lineno <= 0)); then lineno=${BASH_LINENO[0]}; fi
    echo "$source:$lineno:todo: $@ ($funcname)"
    # ${BASH_LINENO[@]}
}
