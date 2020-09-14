h(){
history -d -1;[[ $1 =~ ^(--help$|[1-9]|1[0-7]|-c$|.|-[anprsw]) ]] &&{	history ${@#.};return;}
F=1;l=17
[[ `history|head -n1` =~ ^\ *([0-9]+) ]]
let h=t=HISTCMD-${BASH_REMATCH[1]}
while : ;do
if [ -z "$1" ] ;then
	((F))&&{	history 17;F=;	 }
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Show the next 17? (Enter: abort, Up: from end/newer, Down: from begin, [-]n[-][n] erase by number n or range n-n, Others as deletion substring) `echo -e '\e[0m\n\r'`" m
		case $m in
		$'\033') #ESC
			read -N 1 m
			if [[ $m = [ ]] ;then
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
				#~ C|D) # RG, LF
					#~ echo Get into history completion mode.. now Up or Down retrieve line from the middle to the next older or newer respectively
				esac
			fi;;
		$'\x0a')
			break 2;;
		*)
			read -rei "$m" m
			if [[ $m =~ ^([1-9][0-9]*(-([1-9][0-9]*)?)?\ ?|-[1-9][0-9]*\ ?)+$ ]] ;then
				eval set -- $m
				break
			else
				m=${m//\'/\'}
				eval set -- \"$m\"
				break
			fi;;
		esac
	done
fi
unset IFS s l b u B i j k D
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
		((u=u?u:HISTCMD))
		((u<l)) &&{		m=$u;u=$l;l=$m; }
		let i=u-l+1
		i=$i
		u=$u
		let D=j+k
		((B<l)) &&{ let l-=D;let u-=D;}
		while((i--)) ;do history -d $l 2>/dev/null &&((++k))
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
((b=b>3? b-3: 1))
if((u-D-b+3<=17)) ;then
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
	if(((l=HISTCMD-u+D+3)<7)) ;then
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
}
