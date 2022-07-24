h(){ #BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprsw]$|^\. ]] &&{ history ${@#.};return;}
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
let off=BASH_REMATCH[1]-1
let T=HISTCMD-off
C=;D=;F=1;L=25;U=0
while : ;do
if [ -z "$1" ] ;then
	((F))&&{	history 25;F=;	 }
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Next 25? Up/Down: from last/begin, [-]n[-][n] erase by range, Enter: out. Else: as string to erase `echo -e '\e[0m\n\r'`" m
		case $m in
		$'\x1b') #ESC
			read -N 1 m
			if [[ $m != [ ]] ;then return
			else
				read -N 1 m; echo
				case $m in
				A) #UP
     U=$L
					if((((L+=25))>T)) ;then
						let L-=T
						history |head -$((25-L))
						history $L
					else
						history $L| head -25
					fi;;
				B) #DN
     L=$U
					history $U	| head -25
					((((U-=25))<0)) &&{
						history| head -$((-U))
						let U+=T
					}
				esac
			fi;;
		$'\x0a')	break 2;;
		*)
			read -rei "$m" m
			[[ ! $m =~ ^[1-9][0-9]*-?([1-9][0-9]*)?$|^--?[1-9][0-9]*(-[0-9])?$ ]] &&{
    m=${m//\\/\\\\};m=\"${m//\$/\\\$}\";}
   eval set -- "$m"
			break
		esac
	done
fi
unset IFS s b i j k l u C D
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]];let off=BASH_REMATCH[1]-1
for a in "$@"
{
 let B=HISTCMD-off
 if [[ $a =~ ^(-)?(-[1-9][0-9]*)(-[0-9])?$ ]] ;then
  let b=BASH_REMATCH[2]-U
  if [ "${BASH_REMATCH[1]}" ] ;then
   for i in `eval echo {$b..$((BASH_REMATCH[3]-1-U))}` ;{ history -d $i 2>/dev/null &&((++k));}
   let b+=b+B
		else
   history -d $b
   let b+=B
  fi
	elif [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		l=$a
		let D=j+k
		((B<l)) && let l-=D
		history -d $l 2>/dev/null &&((++j))
		((b=B? B: l))
	elif [[ $a =~ ^([0-9]+)-([1-9][0-9]*)?$ ]] ;then
		l=${BASH_REMATCH[1]}
		u=${BASH_REMATCH[2]}
  ((u=u?u:HISTCMD))
  ((l=l?l:1))
  ((u<l)) &&{		m=$u;u=$l;l=$m; }
  let D=j+k
  ((B<u)) && let u-=D
  ((C=u-l+1))
  while((C--)) ;do history -d $l 2>/dev/null &&((++k))
  done
  b=$l
	else
  a=${a//\//\\/};a=${a//\"/\\\"};a=${a//./\\.};a=${a//\*/\\*}
		a=${a//\?/\\?};a=${a//\[/\\[};a=${a//\]/\\]}
  a=${a//\|/\\|};a=${a//\^/\\^};a=${a//\(/\\(};a=${a//\)/\\)}
  a=${a//\{/\\{};a=${a//\}/\\'}'};a=${a//\$/\\\$}
		if ((${#a}>2)) ;then
			if [[ $a =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then a=.*$a.*
			elif [[ $a =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then a=${BASH_REMATCH[1]}.*
			elif [[ $a =~ ^([[:graph:]].*)[[:space:]]+$ ]] ;then	a=.*${BASH_REMATCH[1]}
			elif [[ $a =~ ^[[:space:]](.*)[[:space:]]+$ ]] ;then	a=${BASH_REMATCH[1]};fi
		elif [[ $a =~ ^[[:space:]].*[[:space:]]+$ ]] ;then	a=.*${BASH_REMATCH[1]}.*
  fi
		D=;IFS=$'\n'
		for u in `history|sed -nE "s/^\s+([0-9]+)\*?\s+$a$/\1/p"`
		{
			((D))||{
				echo -e Line:'\e[41;1;37m'`history $((B-u))|head -1`'\e[40;1;32m'
				b=$u
			}
			history -d $((u-D++))
		}
		! ((D)) &&{ echo No history line match. Did nothing;set -;return;}
  ((D>1)) &&{ echo -ne "and $D following lines ";}
		echo -e has been erased'\e[m'
	fi
	B=$u
}
[[ `history|head -1` =~ ^\ *([0-9]+) ]]
let T=HISTCMD-${BASH_REMATCH[1]}
((u<b))&&{	m=$b;b=$u;u=$m; }
((b=b>4? b-4: 1))
if((u-D-b+3<25)) ;then
	if((HISTCMD-b+3<25)) ;then
		history $((l=25))
	else
		let l=HISTCMD-b+D+3
		history $l |head -n25
	fi
	let h=l-25
else
	history $((HISTCMD-b)) |head -15
	echo '  '...
	if((((l=HISTCMD-u+D+3))<15)) ;then
		history 15;let h=T
	else
		history $l	|head -15
		let h=l-15
	fi
fi
((F))&&break
set --
done
if((C+D)) ;then read -sN1 -p 'Save the modified history (Enter: yes)? ' o
	if [ "$o" = $'\x0a' ];then history -w&&echo saved
	else
		read -N1 -p ' Revert back the modified history (Enter: yes)? ' o
		[ "$o" = $'\x0a' ]&&{ history -c;history -r;}
	fi
fi
IFS=$'\n';i=;for l in `history`
{	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
unset IFS
}
