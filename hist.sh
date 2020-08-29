h(){
if [ -z "$1" ] ;then history -d -1
	b=-12
	history 13;l=13
	IFS=''
	while : ;do
		 echo -e '\033[44;1;37m'
		 read -d '' -sn 1 -p 'Show the next 13? (Enter: no/quit, Space: from newer, Ctrl-b: from begin, [-]0..9[-] delete by number/range, Others as a deletion substring) ' m
		echo -ne '\033[0m'
		case $m in
		$'\x0a')
			unset IFS;return;;
		$'\x20')
			((l+=13))
			history $l| head -n13
		;;
		$'\x02') # Ctrl b
			echo
			((b+=13))
			history | tail -n+$b| head -n13
		;;
		[0-9]|-)
			echo -n $m
			read n
			eval set -- $m$n
			break;;
		*)	echo -n $m
			read n
			s=$m$n
			s=${s//(/\\(}
			eval set -- \'${s//)/\\)}\'
			break;;
		esac
	done
fi
unset IFS
for a
{
if [[ $a =~ --help|-[acnprsw] ]] ;then
	history  -d -1
	history $@
	break
elif [[ $a =~ ^[1-9]+$ ]] ;then
		history -d $a
		l=$a
elif [[ $a =~ ^-?([0-9]+)(-[0-9]+)? ]] ;then
	l=${BASH_REMATCH[1]}
	u=${BASH_REMATCH[2]}
	[ $u ] ||{			# If no UPPER BOUNDARY
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
else
	i=
	if [ ${#a} -gt 2 ] ;then
		for l in `history|sed -nE "s/^\s*([0-9]+)\s+.*$a.*/\1/ p"`
			{ let l-=i++;history -d $l; }
	else
		for l in `history|sed -nE "s/^\s*([0-9]+)\s+$a\$/\1/ p"`
			{ let l-=i++;history -d $l; }
	fi
fi
let l-=5+`history |head -n1| sed -E 's/^\s*([0-9]+).*/\1/ p'`
[ $l -lt 0 ] &&l=0
history |tail -n+$l | head -n13
}
echo
}
