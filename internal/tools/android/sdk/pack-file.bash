# -*- shell-script -*-
out="$1"
package="$2"
files="$3"

cd "$out" || exit 1
for file in $files ; do
    zip -r "$package" "$file" || exit 2
done
cd -
