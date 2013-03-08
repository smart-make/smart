# -*- shell-script -*-
out="$1"
package="$2"
file="$3"

function extract-abi ()
{
    local abi=$(basename $(dirname $1))
    case $abi in
	armeabi|armeabi-v7a|mips|x86)
	    echo "$abi"
	    ;;
	*)
	    echo "smart:error: invalid native lib \"$1\"" > /dev/stderr
	    echo "smart:error: found in \"$file\"" > /dev/stderr
	    echo "smart:error: abi is $abi" > /dev/stderr
	    ;;
    esac
}

for lib in `cat "$file"`; do
    abi=$(extract-abi $lib)
    mkdir -p "$out/lib/$abi" && cp -f "$lib" "$out/lib/$abi" && {
	cd "$out" && zip -r "$package" "lib/$abi/$(basename $lib)"
    }
done
