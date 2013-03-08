# -*- shell-script -*-
out="$1"
package="$2"
file="$3"

cd "$out" && zip -r "$package" "$file"
