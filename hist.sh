h(){
if [ -z "$1" ] ;then history -d -1
	b=-12
	history 13;l=13
	IFS=''
	while : ;do
		 echo -ne '\033[44;1;37m'
		 read -d '' -sn 1 -p 'Show the next 13? (Enter: no/quit, Space: from newer, Ctrl-b: from begin, [-]0..9[-] delete by number/range, Others as a deletion substring) ' m
		echo -ne '\033[0m'
		case $m in
		$'\x0a')
			unset IFS;echo;return;;
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
unset IFS j ll befr B abs
for a
{
if [[ $a =~ --help|-[acnprsw] ]] ;then
	history  -d -1
	history $@
	break
elif [[ $a =~ ^[1-9]+$ ]] ;then
		[[ $befr < $a ]] && let u=a-j
		history -d $u
elif [[ $a =~ ^-?([0-9]+)(-[0-9]+)? ]] ;then
	l=${BASH_REMATCH[1]}
	u=${BASH_REMATCH[2]}
	[ $befr -lt $u ] && let l=u-j
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
	[ ${#a} -gt 2 ] && a=.\*$a.\*
	for l in `history|sed -nE "s/^\s*([0-9]+)\s+$a/\1/ p"`
		{ let l-=i++;history -d $l; }
	break
fi
befr=$u

((B)) ||{
	let B=u-`history |head -n1| sed -E 's/^\s*([0-9]+).*/\1/ p'`
	[ $B -lt 0 ] &&B=0
}
((++j))
}

let s=u-B
((B=u>B? B-3: u-3))
s=${s#-}
((s=s>11? s+3: 15))
history |tail -n+$B | head -n$s

echo
}
