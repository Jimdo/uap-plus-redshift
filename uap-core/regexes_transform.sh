#!/bin/sh
sed '/regex:/s/\(.*\)./\1/' regexes.yaml > regexes_temp.yaml
sed '/regex:/ s/$/#@#@#/' regexes_temp.yaml > regexes_plus.yaml
rm regexes_temp.yaml
mv regexes.yaml regexes.yaml.orig
mv regexes_plus.yaml regexes.yaml
echo “open regexes.yaml in text editor, replace #@#@# with (?i)'"

