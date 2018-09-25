#! /usr/bin/bash
h(){
t=`echo $@ | sed -E 's/[{}\.]/\\\&/g; s/\*/.*/g; s/\?/./; s/\\$/\\\s*$/'`
s=;IFS=$'\n'   #for Windows port Msys: \r\n, for Mac: \r
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
if test "$i"
	then	echo "$i erasure(s)"
	i=$@
	test ${#i} -gt 4 &&{
	a=`echo -e $s |sed -E "s/\s*[0-9]+\s+($t.*)/\1/i; tq; d; :q q"`
	history -s "$a";echo retaining/restoring: "\"$a\""
	}
fi
history -w
}
