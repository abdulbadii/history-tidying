#! /usr/bin/bash
h(){
t=`echo $@ | sed -E 's/[{}\.$]/\\\&/g; s/\*/.*/g; s/\?/./g'`
u=${#t}
[[ $t =~ \.$ ]] &&t="$t?$"
s=;IFS=$'\n'  # change to \r\n for Windows port, \r for Mac port
if [[ `echo $-` =~ x ]] ;then set +x;for a in `history`;{ s="$a\n$s"; };n=`echo -e $s |sed -E "s'^\s*([0-9]+)\s+$t.*'\1'i; tq; d; :q"`;set -x
else
for a in `history`;{ s="$a\n$s"; }
n=`echo -e $s |sed -E "s'^\s*([0-9]+)\s+$t.*'\1'i; tq; d; :q"`
fi
i=0;
# else than Linux add a line to set: IFS=$'\n'
for d in $n
{
if test $i -lt 1 -a $u -gt 5 ;then
	echo retaining the $d th history
else
	history -d $d
fi
let i++
}
echo "$i erasure(s)"
history -w;echo last 21 lines:;history 21
unset IFS # set to default
}
