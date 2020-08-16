h(){
if [ -z "$1" ] ;then history -d -1
	b=1
	history 13;n=13
	while : ;do
		read -n 1 -p 'Show the next 9? (Enter/Spc: from newer , Ctrl-o: from older, 0..9 delete by number, Others to input string, Escape/Ctrl-c quit) ' m
		case $m in
		[0-9]*|-[1-9]*|[\!-~A-z]*)
			read n
			eval set -- $m$n
			break;;
		*)	echo
			if [[ `echo $m|sed -n l` == '\033$' ]] ;then			# ESC
				return
				
			elif [[ `echo $m|sed -n l` == '\017$' ]] ;then			# Ctrl o
				history | tail -n+$b| head -n13
				((b+=13))
			else
				((n+=13))
				history $n| head -n13
			fi;;
		esac
		echo
	done
fi
for a
{
if [[ $a =~ [1-9]+ ]] ;then
	history -d $a
elif [[ $a =~ [0-9]+-([1-9]+)?|-[1-9]+ ]] ;then
	l=${a%-*}
	u=${a#*-}
	[ $u ] ||{			# If no UPPER BOUNDARY
		[ $l ] ||{ history -c;return; } #If no argument but -, it means clean all
		t=`history 1`
		u=${t#*[0-9] }
		u=${t:0: -${#u}}
	}
	((l)) || l=1
	let i=u-l
	((i<0)) &&let i=-i
	((++i))
	while((i--)) ;do
		history -d $l
	done
elif [[ ${a} =~ --help|-[acdnprsw] ]] ;then
	history  -d -1
	history $@
else
	i=;for e in `history|sed -nE "s/^\s*([0-9]+)\s+.*$a.*/\1/i p"`
	{ let e-=i++;history -d $e; }
fi
}
echo
}
