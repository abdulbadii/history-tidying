#! /usr/bin/bash
h(){
t=`echo $@ | sed -E 's/[{}\.$]/\\\&/g; s/\*/.*/g; s/\?/./g'`
[[ $t =~ \.$ ]] &&t="$t?$"
s=;IFS=$'\n'
for a in `history`;{ s="$a\n$s"; }
n=`echo -e $s |sed -E "s/^\s*([0-9]+)\s+$t.*/\1/i; tq; d; :q"`
i=0;
for d in $n
{
test $i -lt 1 &&echo retaining the $d th history ||history -d $d
let i++
}
test "$i" -gt 1 &&echo "$i erasures"
history -w;echo last 21:;history 21
}
