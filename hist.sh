h(){ #BEGIN h
[[ $1 =~ ^(--help$|-[anprsw]|.) ]] &&{	history ${@#.};return;}
C=;D=;F=1;l=17
[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
let h=t=HISTCMD-${BASH_REMATCH[1]}
while : ;do
if [ -z "$1" ] ;then
	((F))&&{	history 17;F=;	 }
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Show the next 17? (Enter: abort, Up: from end/newer, Down: from begin, [-]n[-][n] erase by number n or range n-n, Others as deletion substring) `echo -e '\e[0m\n\r'`" m
		case $m in
		$'\x1b') #ESC
			read -N 1 m
			if [[ $m != [ ]] ;then return
			else
				read -N 1 m
				echo
				case $m in
				A) #UP
					if((((l+=17))>t)) ;then
						let l-=t
						history |head -n$((17-l))
						history $l
					else
						history $l| head -n17
					fi;;
				B) #DN
					history $h	| head -n17
					((((h-=17))<0)) &&{
						history	$t| head -n$((-h))
						let h+=t
					};;
				esac
			fi;;
		$'\x0a')	break 2;;
		*)
			read -rei "$m" m
			[[ ! $m =~ ^([1-9][0-9]*)?-?[1-9][0-9]*$ ]] &&
				m=\"${m//\'/\'}\"
			eval set -- $m
			break
		esac
	done
fi
unset IFS k s l b u B i j C D
for a
{
	if [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		u=$a
		let D=j+k
		((B<u)) && let u-=D
		history -d $u 2>/dev/null &&((++j))
		((b=B? B: u))
	elif [[ $a =~ ^([1-9][0-9]*)-([1-9][0-9]*)?$ ]] || [[ $a =~ ^()-([1-9][0-9]*)$ ]] ;then
		l=${BASH_REMATCH[1]}
		u=${BASH_REMATCH[2]}
		((l=l? l: 1))
		((u=u?u:HISTCMD-1))
		((u<l)) &&{		m=$u;u=$l;l=$m; }
		let D=j+k
		((B<u)) && let u-=D
		let C=u-l+1
		while((C--)) ;do history -d $l 2>/dev/null &&((++k))
		done
		b=$l
	else
		a=${a//\\/\\};a=${a//#/\#}
		a=${a//'/\'};a=${a//\"/\"};a=${a//./\.};a=${a//\*/\*}
		a=${a//\?/\\?};a=${a//\[/\\[};a=${a//\]/\\]};a=${a//\(/\\(};a=${a//\)/\\)}
		a=${a//\{/\{};a=${a//\}/\}}
		((${#a}>1)) &&{
			if [[ $a =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then
				a=.\*$a.\*
			elif [[ $a =~ ^\ +.*[[:graph:]]+$ ]] ;then
				a=$a.\*
			elif [[ $a =~ ^[[:graph:]].*\ +$ ]] ;then
				a=.\*$a
			fi
		}
		D=;IFS=$'\n'
		for u in `history|sed -nE "s#^\s*([0-9]+)\s+$a\\$#\1#p"`
		{
			((D))||{
				let m=HISTCMD-u
				echo -e Line:'\e[41;1;37m'`history $m|head -1`'\e[m'
				b=$u
			}
			history -d $((u-D++))
		}
		if ! ((D)) ;then echo No history line matched. Did nothing;set --;continue 2
		elif ((D>1)) ;then echo -e and else following it, up to '\e[1;32m'$D lines have been erased'\e[m'
		else echo has been erased
		fi
	fi
	B=$u
}
[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
let t=HISTCMD-${BASH_REMATCH[1]}
((u<b))&&{	m=$b;b=$u;u=$m; }
((b=b>4? b-4: 1))
if((u-D-b+3<17)) ;then
	if((HISTCMD-b+3<17)) ;then
		history $((l=17))
	else
		let l=HISTCMD-b+D+3
		history $l |head -n17
	fi
	let h=l-17
else
	history $((HISTCMD-b)) |head -n7
	echo '  '...
	if((((l=HISTCMD-u+D+3))<7)) ;then
		history 7;let h=t
	else
		history $l	|head -n7
		let h=l-7
	fi
fi
((F))&&break
set --
done
IFS=$'\n';i=;for l in `history`
{	[[ $l =~ ^\ *([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
unset IFS
((C+D))&&{ read -N 1 -p 'Save the updated history (Enter: yes)? ' o
	if [ "$o" = $'\x0a' ];then history -w&&echo saved
	else
		read -N 1 -p ' Revert back the updated history (Y: yes)? ' o
		[ "$o" = y ]&&{ history -c;history -r;}
	fi
}
}
