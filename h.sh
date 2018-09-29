#! /usr/bin/bash
h(){
t=`echo $@ | sed -E 's/[{}\.$]/\\\&/g; s/\*/.*/g; s/\?/./g'`
u=${t//.?/};u=${#u}
[[ $t =~ \.\?$ ]] &&t="$t$"
s=;IFS=$'\n'  # change to \r\n for Windows port, \r for Mac port
for a in `history`;{ s="$a\n$s"; }
n=`echo -e $s |sed -E "s'^\s*([0-9]+)\s+$t.*'\1'i; tq; d; :q"`
i=0;
# else than Linux add a line to set: IFS=$'\n'
for d in $n
{
if test $i -eq 0 -a $u -gt 5 ;then echo retaining the $d th history
else	history -d $d
fi
let i++
}
echo "$i erasure(s)"
history -w;echo last 21 lines:;history 21
unset IFS # set to default
}
