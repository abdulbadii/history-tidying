h(){
if [ -z "$1" ] ;then
	history  -d -1
	history 21
	return
elif [[ $1 =~ --help|-[acdnprsw] ]] ;then
	history  -d -1
	history $@
	return
fi
for a
{
case ${a} in
-[1-9]*|[0-9]*-*)
		l=${a%-*}
		u=${a#*-}
		[ $u ] ||{			# If no UPPER BOUNDARY
			((l))||{ history -c;return; } #If no argument but - means clean all
			t=`history 1`
			u=${t#*[0-9] }
			u=${t:0: -${#u}}
		}
		((l)) || l=1
		let i=u-l
		((i<0)) &&let i=-i
		((++i))
		while((i--));do
			history -d $l
		done;;
[1-9]*)
	history -d $a
	;;
*) i=;for e in `history|sed -nE "s/^\s*([0-9]+)\s+.*$a.*/\1/i p"`
	{ let e-=i++;history -d $e; };;
esac
}
}
