# -*- shell-script -*-
out="$1"
package="$2"
file="$3"

function extract-abi ()
{
    local target_abi=$(basename $(dirname $1))
    local abi=$(sed -e 's/^android\-[0-9]*\-//' <<< "$target_abi")
    case $abi in
	armeabi|armeabi-v7a|mips|x86)
	    echo "$abi"
	    ;;
	*)
	    echo "smart: ERROR: Invalid native lib \"$1\"" > /dev/stderr
	    echo "smart: ERROR: Found in \"$file\"" > /dev/stderr
	    echo "smart: ERROR: The ABI is $abi" > /dev/stderr
	    ;;
    esac
}

## First remove the old lib directory!
rm -rf "$out/lib"

for lib in `cat "$file"`; do
    abi=$(extract-abi $lib)
    mkdir -p "$out/lib/$abi" && cp -f "$lib" "$out/lib/$abi" && {
	cd "$out" || exit 1
	zip -r "$package" "lib/$abi/$(basename $lib)" || exit 2
	cd - > /dev/null
    }
done
