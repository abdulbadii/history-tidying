h(){
F=1
while : ;do
t=`history|head -n1`
of=${t#*[0-9] }
of=${t:0: -${#of}}
t=
IFS=$'\n'
for ll in `history` ;{ ((t++)); }

if [ -z "$1" ] ;then
	((F)) &&{	history -d -1;history 17;F=;	}
	b=1
	l=17
	IFS=''
	while : ;do
		 echo -ne '\033[44;1;37m'
		 read -d '' -sn 1 -p 'Show the next 17? (Enter: no/quit, Space: from newer, Ctrl-b: from begin, [-]0..9[-] delete by number/range, Others as a deletion substring) ' m
		echo -ne '\033[0m'
		case $m in
		$'\x20') #SPC
			echo
			if [ $((l+=17)) -gt $t ] ;then
				let l-=t-1
				history |head -n$((17-l))
				echo;history $l
			else
				history $l| head -n17
			fi;;
		[0-9]|-)	echo -n $m
			read n
			eval set -- $m$n
			break;;
		$'\x02') # Ctrl b
			echo
			history | tail -n+$b	| head -n17
			if [ $((b+=17)) -gt $t ]; then
				let b-=t
				history	|head -n$b
				let ++b
			fi;;
		$'\x0a'|$'\x1b')
			break 2;;
		*)	echo -n $m
			read n
			s=$m$n
			s=${s//(/\\(}
			eval set -- \'${s//)/\\)}\'
			break;;
		esac
	done
fi

unset IFS j s l b u; B=0
for a
{
if [[ $a =~ --help|-[acnprsw] ]] ;then
	history  -d -1
	history $@
	unset IFS;return
elif [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		u=$a
		[ $B -lt $u ] && let u-=j
		history -d $u
elif [[ $a =~ ^([1-9][0-9]*)-([1-9][0-9]*)?$ ]] || [[ $a =~ ^()-([1-9][0-9]*)$ ]] ;then
	l=${BASH_REMATCH[1]}
	u=${BASH_REMATCH[2]}
	((u=u? u: t))
	let i=u-$((l=l? l: 1))
	let i=1+${i#-}
	[ $B -lt $u ] && let u-=i+j
	while((i--)) ;do history -d $l
	done
elif [ "$a" = - ] ;then
	history -d -1;break 2
else
	i=
	[ ${#a} -gt 2 ] && a=.\*$a.\*
	for l in `history|sed -nE "s/^\s*([0-9]+)\s+$a\$/\1/ p"`
		{ let l-=i++;history -d $l; }
	break
fi
((++j))
b=$B
B=$u
}

((s=b? u-b: 17))
s=${s#-}
((bo=u>b? b-4-of: u-4-of))
((bo<0))&&bo=0
history |tail -n+$bo |head -n$((s=s>13? s+3: 17))
((F)) &&break
set --
done
IFS=$'\n'
i=;for l in `history`
{
	[[ $l =~ ^[\ \\t]*([0-9]+)\*?[\ \\t]*$ ]] &&{
		let l=BASH_REMATCH[1]-i++
		history -d $l
	}
}
unset IFS;echo
}
