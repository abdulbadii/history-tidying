#! /usr/bin/bash
h(){
# Literal to regex conversion
t=`echo $@ | sed -E 's/[{}\.]/\\\&/g; s/\*/.*/g; s/\?/./; s/\\$/\\\s*$/'`
s=;IFS=$'\n' #for Windows port Msys: \r\n, for Mac: \r
for a in `history`;{ s="$a\n$s"; }
s=`echo -e $s |sed -E "s/\s*([0-9]+)\s+$t.*/\1/i; tq; d; :q"`
i=
#for else than linux set it back here to \n so this line: IFS=$'\n'
for d in $s
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
}
