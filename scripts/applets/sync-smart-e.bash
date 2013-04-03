#
#  Copyright (C) 2013, by Duzy Chan <code@duzy.info>
#  
#  All rights reserved.
#
PASSWORD="l9-09=zc+348u87"
function save-smart ()
{
    local s1=$(file-size $1)
    local s2=$(file-size $1.e)

    if (( 0 == $s1 )); then
	echo "smart: save: ignore empty file ($1)"
	return
    elif (( 0 < $s1 && 0 < $s2 )); then
	local t1=$(file-time $1)
	local t2=$(file-time $1.e)

	if (( $t1 < $t2 )); then
	    echo "smart: save: file not updated ($1)"
	    return
	fi

	local checkname="$1.check.$(date +%s)"
	openssl enc -d -aes-128-cfb -k "$PASSWORD" -in $1.e -out $checkname || {
	    return
	}

	local diff=$(diff $1 $checkname)
	rm -f $checkname
	
	if [[ "x$diff" == "x" ]]; then
	    echo "smart: save: file not changed ($1)"
	    return
	fi

	local backupname="$1.e.backup.$(date +%s)"
	mv -f $1.e $backupname || {
	    echo "smart: save: backup error ($1)"
	    return
	}
    elif (( 0 < $s1 && 0 == $s2 )); then
	[[ -f $1.e ]] && rm -f $1.e
    fi

    openssl enc -e -aes-128-cfb -k "$PASSWORD" -in $1 -out $1.e || {
	rm -f $1.e
	echo "smart: save: save error ($1)"
	return
    }

    echo "smart: save: file saved ($1)"
    gitignore $1
}

function restore-smart ()
{
    local s=$(file-size $1.e)
    if (( 0 == $s )); then
	touch $1
	return
    fi

    local t1=$(file-time $1)
    local t2=$(file-time $1.e)

    if (( $t1 > $t2 )); then
	echo "smart: restore: file already updated ($1)"
	return
    fi

    local backupname="$1.backup.$(date +%s)"
    if [[ -f $1 ]]; then
	mv -f $1 $backupname || {
	    echo "smart: restore: backup error ($1)"
	    return
	}
    fi

    openssl enc -d -aes-128-cfb -k "$PASSWORD" -in $1.e -out $1 || {
	rm -f $1
	echo "smart: restore: restore error ($1)"
	return
    }

    echo "smart: restore: file restored ($1)" #&& sleep 1
    gitignore $1
}

function file-time ()
{
    if [[ -f $1 ]]; then
	stat -c %Y $1
    else
	echo 0
    fi
}

function file-size ()
{
    if [[ -f $1 ]]; then
	stat -c %s $1
    else
	echo 0
    fi
}

function gitignore ()
{
    local d=$(dirname $1)
    local gitignore="$d/.gitignore"

    local s
    local addignore
    local ignore="/$(basename $1)"
    if [[ -f $gitignore ]]; then
	s=$(grep "$ignore" $gitignore)
    else
	addignore="yes"
    fi
    if [[ "x$s" == "x" ]]; then
	echo "$ignore" >> $gitignore
	echo "$ignore.backup.*" >> $gitignore
	echo "$ignore.e.backup.*" >> $gitignore
	if [[ "x$addignore" == "xyes" ]]; then
	    cd $d && {
		git add .gitignore
		cd - > /dev/null
	    }
	fi
	echo "gitignore: $1"
    fi
}

function main ()
{
    case $1 in
	-save)
	    save-smart "$2"
	    ;;
	-restore)
	    restore-smart "$2"
	    ;;
    esac
}
