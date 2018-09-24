#! /usr/bin/bash
h(){
# Literal to regex conversion
t=`echo $@ | sed -E 's/[{}\.]/\\\&/g; s/\*/.*/g; s/\?/./; s/\\$/\\\s*$/'`
s=;IFS=$'\n'
for a in `history`;{ s="$a\n$s"; }
a=`echo -e $s |sed -E "s/\s*[0-9]+\s+($t.*)/\1/i; tq; d; :q q"`
s=`echo -e $s |sed -E "s/\s*([0-9]+)\s+$t.*/\1/i; tq; d; :q"`
i=;for d in $s
{
history -d $d
echo erasing $d
let i++
}
if test "$i"
	then	echo "$i erasure(s)"
	i=${@};test ${#i} -gt 3 &&{ history -s "$a";echo retaining/restoring: "\"$a\""; }
fi
}
