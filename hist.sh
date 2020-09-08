h(){
history -d -1;[[ $1 =~ --help|-[acnprsw] ]] &&{	history $@;return;}
F=1;h=;l=17
[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
let t=HISTCMD-${BASH_REMATCH[1]}
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
					history $((t-h))	| head -n17
					((((h+=17))>t)) &&{
						history	$t| head -n$((h-t))
						let h-=t
					};;
				esac
			fi;;
		$'\x0a')
			break 2;;
		*)
			read -rei "$m" m
			if [[ $m =~ ^([1-9][0-9]*)?-?[1-9][0-9]*$ ]] ;then
				eval set -- $m
				break
			else
				eval set -- \'$m\'
				break
			fi;;
		esac
	done
fi
unset IFS k s l b u B i j D
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
		let i=u-l+1
		while((i--)) ;do history -d $l 2>/dev/null &&((++k))
		done
		b=$l
	else
		a=${a//\\/\\};a=${a//#/\#}
		a=${a//'/\\'};a=${a//"/\\"};a=${a//./\\.};a=${a//\*/\\*}
		a=${a//\?/\\?};a=${a//\[/\\[};a=${a//\]/\\]};a=${a//\(/\\(};a=${a//\)/\\)};a=${a//\{/\{}
		a=${a//\}/\}}
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
			((D)) ||{
				let m=HISTCMD-u
				echo -e Line: '\033[41;1;37m'`history $m|head -n1`'\033[0m'
				b=$u
			}
			history -d $((u-D++))
		}
		if ! ((D)) ;then echo No history line matched. Did nothing;set --;continue 2
		elif ((D>1)) ;then echo -e and else after this, up to $D lines have been erased
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
else
	history $((HISTCMD-b)) |head -n7
	echo '  '...
	history $((l=HISTCMD-u+D+3)) |head -n7
fi
let l+=17
((F))&&break
set --
done
IFS=$'\n';i=;for l in `history`
{	[[ $l =~ ^\ *([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
unset IFS
}
