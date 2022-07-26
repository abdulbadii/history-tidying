h(){ #BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
let B=HISTCMD-BASH_REMATCH[1]+1
did=;C=;D=;F=1;L=25;U=0
while : ;do
if [ -z "$1" ] ;then
	((F))&&{	history 25;F=;	 }
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Next 25? Up/Down: from last/begin, [-]n[-][n] erase by range, Enter: out. Else: as string to erase `echo -e '\e[0m\n\r'`" m
		case $m in
		$'\x1b') # \e ESC
			read -N 1 m
			if [[ $m != [ ]] ;then return
			else
				read -N 1 m; echo
				case $m in
				A) #UP
     U=$L
					if((((L+=25))>B)) ;then
						let L-=B
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
						let U+=B
					}
				esac
			fi;;
		$'\x0a')	break 2;;
		*)
			read -rei "$m" m
			[[ ! $m =~ ^[1-9][0-9]*-?([1-9][0-9]*)?$|^--?[1-9][0-9]*(-[0-9])?$ ]] &&{
    m=${m//\\/\\\\};m=${m//\"/\\\"};m=\"${m//\$/\\\$}\";}
   eval set -- $m
			break
		esac
	done
fi
unset IFS s b i j k l u C D W ln
for a in "$@"
{
 if [[ $a =~ ^-([1-9][0-9]*)?$|^--([1-9][0-9]*)-?([1-9][0-9]*)?$ ]] ;then
  let e=${BASH_REMATCH[3]:-1}+1
  ! ((d=${BASH_REMATCH[2]})) &&{
    ((e=d=${BASH_REMATCH[1]:-1}))
  }
  ((e>d)) || ((d>25)) || ((((d+=U))>B)) &&{ echo $d or $e is invalid number range;set --;continue 2;}
  for i in `eval echo {$d..$((e+U))}` ;{
   history -d -$i 2>/dev/null
  }
  if ((d<14)) ;then history 25; else history $((d+12)) |head -25 ;fi
  did=1;set --;continue 2
	elif [[ $a =~ ^[1-9][0-9]*$ ]] ;then
		u=$a
		let D=j+k
		((u>HISTCMD)) &&{
   !((D)) &&{ echo $u is invalid number range;continue 2;}
   let u-=D
  }
		history -d $l 2>/dev/null &&((++j))
		did=1;((b=B? B: u))
	elif [[ $a =~ ^([0-9]+)-([1-9][0-9]*)?$ ]] ;then
		l=${BASH_REMATCH[1]}
  ((l=l?l:1))
		u=${BASH_REMATCH[2]}
  ((u=u?u:HISTCMD))
  ((u<l)) &&{		m=$u;u=$l;l=$m; }
  ((u>HISTCMD)) || ((l==u)) &&{ echo $l and/or $u is invalid number range;continue 2;}
  let D=j+k
  ((u>B)) &&{
   let u-=D
   !((D)) || ((u<B)) &&{ echo $u is invalid number range;continue 2;}
  }
  let did=C=u-l+1
  while((C--)) ;do history -d $l 2>/dev/null &&((++k));done
  b=$l
	else
	 ((W=${#a}>2)); o=$a
  a=${a//\//\\/};a=${a//\*/\\*};a=${a//\\.\\.\\./.*}
  a=${a//\+/\\+};a=${a//\|/\\|};a=${a//\^/\\^};a=${a//\?/\\?};
  a=${a//\[/\\[};a=${a//\(/\\(};a=${a//\{/\\{}
  a=${a//\]/\\]};a=${a//\)/\\)};a=${a//\}/\\'}'}
  a=${a//\$/\\\$}
		if((W)) ;then
			if [[ $a =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then a=.*$a.*
			elif [[ $a =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then a=${BASH_REMATCH[1]}.*
			elif [[ $a =~ ^([[:graph:]].*)[[:space:]]+$ ]] ;then	a=.*${BASH_REMATCH[1]}
			elif [[ $a =~ ^[[:space:]](.*)[[:space:]]+$ ]] ;then	a=${BASH_REMATCH[1]};fi
		elif [[ $a =~ ^[[:space:]](.*)[[:space:]]+$ ]] ;then	a=.*${BASH_REMATCH[1]}.*
  fi
		D=;IFS=$'\n'
		for u in `history|sed -nE "s/^\s+([0-9]+)\*?\s+$a$/\1/p"`
		{
			echo -e '\e[41;1;37m'`history $((B-u+1))|head -1`'\e[m'
			((D)) || b=$u
   let ln[D++]=u
		}
		! ((D)) &&{ echo -e "\e[41;1;37m$o\e[m wasn't found, did nothing";set --;continue 2;}
  unset IFS;echo -en '\e[40;1;32m'
  read -N1 -p "Delete $D line(s) above from command history? (Enter: yes Else: no) " h
  [[ $h = $'\xa' ]] ||{ echo;set --;continue 2;}
  for i	in `eval echo {$((D-1))..0}` ;{ history -d ${ln[i]} 2>/dev/null;}
  echo -e "Finish the $D line(s) deletion\e[m";did=1
	fi
	B=$u
 [[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
 let B=HISTCMD-BASH_REMATCH[1]+1
}
let C=HISTCMD-b
((u<b))&&{	m=$b;b=$u;u=$m; }
((b=b>4? b-4: 1))
if((u-D-b+3<25)) ;then
	if((C+3<25)) ;then
		history $((l=25))
	else
		let l=C+D+3
		history $l |head -25
	fi
	let h=l-25
else
	history $C |head -15
	echo '  '...
	if((((l=B-u+D+3))<15)) ;then
		history 15;let h=B
	else
		history $l	|head -15
		let h=l-15
	fi
fi
((F))&&break
set --
done
if((did)) ;then read -sN1 -p 'Save the modified history (Enter: yes)? ' o
	if [[ $o = $'\xa' ]];then
  history -w&&echo ..saved
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
	else
		read -N1 -p ' Revert back the modified history (Enter: yes)? ' o
		[ "$o" = $'\xa' ]&&{ history -c;history -r;}
	fi
fi
unset IFS
}
