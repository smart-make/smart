#!/bin/bash
type=$1
loc=$2
name=$3

echo "smart: Entering directory \`$loc'"
(
    cd $loc
    echo "go: $type.$name"
    #go build -o $name
    go install
    cd - > /dev/null
)
echo "smart: Leavning directory \`$loc'"
