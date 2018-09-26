#! /usr/bin/bash
h(){
t=`echo $@ | sed -E 's/[{}\.]/\\\&/g; s/\*/.*/g; s/\?/./; s/\\$/\\\s*$/'`
s=;IFS=$'\n'   # set it for Windows port, Msys: \r\n, Mac: \r
for a in `history`;{ s="$a\n$s"; }
n=`echo -e $s |sed -E "s/\s*([0-9]+)\s+$t.*/\1/i; tq; d; :q"`
i=
# Else than linux here set it back to \n thus: IFS=$'\n'
for d in $n
{
history -d $d
echo erasing $d
let i++
}
if test "$i" -gt 2
	then	echo "$i erasures"
	i=$@
	test ${#i} -gt 4 || [[ $i =~ ^[a-z0-9_.\;]{3,} ]] &&{
	a=`echo -e $s |sed -E "s/\s*[0-9]+\s+($t.*)/\1/i; tq; d; :q q"`
	history -s "$a";echo restoring: "\"$a\""
	}
fi
history -w;history
}
