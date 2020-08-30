h(){
F=1
while : ;do
if [ -z "$1" ] ;then
	b=-12;l=13
	((F)) &&{
		history -d -1
		history 13;
	}
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
unset IFS j s; B=$1;bfr=$1
for a
{
if [[ $a =~ --help|-[acnprsw] ]] ;then
	history  -d -1
	history $@
	unset IFS;return
elif [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		u=$a
		[[ $bfr < $u ]] &&{
			let u-=j
			B=$bfr
		}
		history -d $u
elif [[ $a =~ ^-?[1-9][0-9]*-?([1-9][0-9]*)?$ ]] ;then
	l=${BASH_REMATCH[1]}
	u=${BASH_REMATCH[2]}
	[ $bfr -lt $u ] && let l=u-j
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
	[[ $bfr < $u ]] &&{
		let u-=i+j
		B=$bfr
	}
else
	i=
	[ ${#a} -gt 2 ] && a=.\*$a.\*
	for l in `history|sed -nE "s/^\s*([0-9]+)\s+$a\$/\1/ p"`
		{ let l-=i++;history -d $l; }
	break
fi
bfr=$u
ad=`history |head -n1| sed -E 's/^\s*([0-9]+).*/\1/'`
((++j))
}
let s=u-B
((B=u>B? B-4-ad: u-4-ad))
[[ $B < 0 ]] &&B=0
s=${s#-}
((s=s>11? s+3: 15))
echo;history |tail -n+$B |head -n$s
F=;eval set --
done
}
