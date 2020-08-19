h(){
if [ -z "$1" ] ;then history -d -1
	b=-12;f=
	history 13;l=13
	while : ;do
		read -n 1 -p 'Show the next 13? (Enter/Spc: from newer , Ctrl-o: from older, Escape/Ctrl-C quit, 0..9 delete by number, Others is as a deletion substring) ' m
		case $m in
		[0-9]*|-[1-9]*|[\!-~A-z]*)
			read n
			s=$m$n
			s=${s//(/\\(}
			eval set -- ${s//)/\\)}
			break;;
		*)	echo
			if [[ `echo $m|sed -n l` == '\033$' ]] ;then			# ESC
				return
			elif [[ `echo $m|sed -n l` == '\017$' ]] ;then		# Ctrl o
				echo
				((b+=13))
				history | tail -n+$b| head -n13
				f=1
			else
				((l+=13))
				history $l| head -n13
				f=
			fi;;
		esac
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
	i=
	if [ ${#a} -gt 2 ] ;then
        for e in `history|sed -nE "s/^\s*([0-9]+)\s+.*$a.*/\1/i p"`
        { let e-=i++;history -d $e; }
    else
        for e in `history|sed -nE "s/^\s*([0-9]+)\s+$a\$/\1/i p"`
        { let e-=i++;history -d $e; }
    fi
	if [ $f ] ;then
		history | tail -n+$b| head -n13
	else
		history $l| head -n13
	fi
fi
}
echo
}
