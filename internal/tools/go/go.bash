#!/bin/bash
type=$1
loc=$2
name=$3

if [[ "x$GOPATH" == "x" ]]; then
    echo "GOPATH is not defined!"
    exit 1
fi

echo "smart: Entering directory \`$loc'"
(
    cd $loc
    echo "go: $type.$name"
    case $type in
	*)
            #go build -o $name
	    go install
	    ;;
    esac
    cd - > /dev/null
)
echo "smart: Leavning directory \`$loc'"
