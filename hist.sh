h(){
if [ -z "$1" ] ;then history  -d -1
	b=1
	history 17;n=17
	while : ;do
	read -n 1 -p 'Show the next 9 more (Enter/Spacebar : from newer list, b : from beginning, 0..9 delete the number history, other is quit)? ' m
	if [[ $m == [0-9]* ]] ;then
		read n
		eval set -- $m$n
		break
	elif [ "$m" == "b" ] ;then
		echo
		history | tail -n+$b| head -n9
		((b+=9))
	elif [ -z "$m" ] ;then
		((n+=9))
		history $n| head -n9
	else break;
	fi
	done
fi
for a
{
case ${a} in
--help|-[acdnprsw])
	history  -d -1
	history $@;;
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
	history -d $a;;
*) i=;for e in `history|sed -nE "s/^\s*([0-9]+)\s+.*$a.*/\1/i p"`
	{ let e-=i++;history -d $e; };;
esac
}
}
