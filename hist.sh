h(){
F=1
while : ;do
if [ -z "$1" ] ;then
	((F)) &&{	history -d -1;history 17;F=;	}
	b=1
	l=17
	IFS=''
	while : ;do
		[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
		o=${BASH_REMATCH[1]}
		t='\!'
		printf -vT ${t@P}
		let t=T-o+1
		echo -ne '\033[44;1;37m'
		read -d '' -sn 1 -p 'Show the next 17? (Enter: abort, Up: from end/newer, Down: from begin, [-]n[-][n] erase by number n (range n-n), Others as deletion substring) ' m
		echo -ne '\033[0m'
		case $m in
		$'\x1b') #ESC
			read -N 2 n
			echo
			case $n in
			[A) #UP
				if [ $((l+=17)) -gt $t ] ;then
					let l-=t
					history |head -n$((17-l))
					echo;history $l
				else
					history $l| head -n17
				fi;;
			[B) #DN
				history | tail -n+$b	| head -n17
				if [ $((b+=17)) -gt $t ]; then
					let b-=t
					history	|head -n$b
					let ++b
				fi;;
			esac;;
		[0-9]|-)	echo -n $m
			read n
			eval set -- $m$n
			break;;
		$'\x0a')
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

unset IFS i j k s l b u; B=0
for a
{
[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
o=${BASH_REMATCH[1]}
t='\!'
printf -vT ${t@P}
let t=T-o+1
if((F)) &&[[ $a =~ --help|-[acnprsw] ]] ;then
	history  -d -1
	history $@
	unset IFS;return
elif [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		u=$a
		[ $B -lt $u ] && let u-=j+k
		history -d $u 2>/dev/null &&((++j))
		b=$B
elif [[ $a =~ ^([1-9][0-9]*)-([1-9][0-9]*)?$ ]] || [[ $a =~ ^()-([1-9][0-9]*)$ ]] ;then
	l=${BASH_REMATCH[1]}
	u=${BASH_REMATCH[2]}
	((l=l? l: 1))
	((u=u? u: T))
	((u<l)) &&{
		m=$u;u=$l;l=$m
	}
	[ $B -lt $u ] && let u-=j+k
	let i=u-l
	while((i--)) ;do history -d $l 2>/dev/null &&((++k))
	done
	b=$l
elif ((F)) && [ "$a" = - ] ;then history -d -1;break 2
else
	a=${a//\\/\\\\}
	a=${a//\//\\/}
	a=${a//'/\\'}
	a=${a//"/\\"}
	a=${a//./\\.}
	a=${a//\*/\\*}
	a=${a//\?/\\?}
	a=${a//\[/\\[}
	a=${a//\]/\\]}
	a=${a//\(/\\(}
	a=${a//\)/\\)}
	a=${a//\{/\\{}
	a=${a//\}/\\\}}
	[ ${#a} -gt 1 ] &&{
		if [[ $a =~ ^\ +[[:graph:]].*[[:graph:]]\ +$ ]] ;then
			:
		elif [[ $a =~ ^\ +.*[[:graph:]]+$ ]] ;then
			a=$a.\*
		elif [[ $a =~ ^[[:graph:]].*\ +$ ]] ;then
			a=.\*$a
		else	a=.\*$a.\*
		fi
	}
	i=;IFS=$'\n'
	for u in `history|sed -nE "s/^\s*([0-9]+)\s+$a\$/\1/p"`
	{
		((i)) ||{
			let m=T-u+1
			echo -e Line: '\033[41;1;37m'`history $m|head -n1`'\033[0m'
			b=$u
		}
		history -d $((u-i++))
	}
	if ! ((i)) ;then echo No history line matched. Did nothing;set --;continue 2
	elif ((i>1)) ;then echo -e and else after it up to $i lines have been erased
	else echo has been erased
	fi
fi
B=$u
}

let dt=i+j+k
((u<b))&&{
	m=$b;b=$u;u=$m
}
((b=b>3? b-3: 1))
if((u-b<17)) ;then
	if((T-b<17)) ;then history 17
	else	history |tail -n+$b |head -n17 ;fi
else
	history |tail -n+$b |head -n7
	echo '  '...
	history $((T-u+dt-3)) |head -n7
fi
((F)) &&break
set --
done
IFS=$'\n';i=;for l in `history`
{
	[[ $l =~ ^\ *([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++))
}
unset IFS;echo
}
