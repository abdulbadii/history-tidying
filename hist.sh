h(){ #BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
((B=HISTCMD-(OF=BASH_REMATCH[1]-1)))
F=1;L=25;U=0;did=
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
		$'\xa')	break 2;;
		*)   			read -rei "$m" m ;break
		esac
	done
fi
unset IFS s b i j k l u C D W ln
if [[ $m =~ ^[0-9]+-?[0-9]*([[:space:]]+.+)?$ ]] ;then
 set -- $m
 for a in "$@" ;{
  [[ $a =~ [^-0-9] ]] &&{ echo ignoring this non pure numeric range; continue;}
  [[ $a =~ ^([0-9]+)(-([1-9][0-9]*)?)?$ ]]
  let l=u=BASH_REMATCH[1]
  ((l<++OF)) &&{ echo left end number is less than history start number $OF;}
  ((l=u=l?l:1))
  [[ ${BASH_REMATCH[2]} ]] && u=${BASH_REMATCH[3]:-$HISTCMD}
  ((u<l)) &&{ m=$u;u=$l;l=$m; }
  ((u>HISTCMD)) &&{ echo $l-$u is invalid number range;continue;}
  for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null
  }
  did=1
  [[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]];let OF=BASH_REMATCH[1]-1
}
elif [[ $m =~ ^-([1-9][0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]] ;then
 ((e=BASH_REMATCH[3] ? ${BASH_REMATCH[4]:-1}+1 :1))
 ! ((d=${BASH_REMATCH[2]})) &&{
   ((e=d=${BASH_REMATCH[1]:-1}))
 }
 ((e>d)) || ((d>25)) || ((((d+=U))>B)) &&{ echo $d or $e is invalid number range;set --;continue 2;}
 for i in `eval echo {$d..$((e+U))}` ;{
  history -d -$i 2>/dev/null
 }
 if ((d<14)) ;then history 25; else history $((d+12)) |head -25 ;fi
 did=1;set --;continue 2
else
 m=${m//\\/\\\\};m=${m//\"/\\\"}
 ((W=${#m}>2));
 a=${m//\//\\/};a=${a//\*/\\*};a=${a//.../.*}
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
 for u in `history|sed -nE "s/^\s+([0-9]+)\*?\s+($a)$/\1-\2/p"`
 {
  [[ $u =~ ^([0-9]+)-(.+) ]]
  let ln[D++]=BASH_REMATCH[1]
  echo -en '\e[41;1;37m';echo -n ${BASH_REMATCH[2]} ;echo -e '\e[m'
  ((D)) || b=$u
 }
 ! ((D)) &&{ echo -e "\e[41;1;37m$1\e[m wasn't found, did nothing";set --;continue 2;}
 echo -en '\e[40;1;32m'
 read -N1 -p "Delete $D line(s) above from command history? (Enter: yes Else: no) " h
 [[ $h = $'\xa' ]] ||{ echo;set --;continue 2;}
 unset IFS
 for i	in `eval echo {$((D-1))..0}`
 {
  history -d ${ln[i]} 2>/dev/null;}
 echo -e "Finished $D line(s) deletion\e[m";did=1
fi
B=$u
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
let B=HISTCMD-BASH_REMATCH[1]+1
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
((did)) &&{ read -sN1 -p 'Save the modified history (Enter: yes)? ' o
	if [[ $o = $'\xa' ]];then
  history -w&&echo ..saved
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
	else
		read -N1 -p ' Revert back the modified history (Enter: yes)? ' o
		[ "$o" = $'\xa' ]&&{ history -c;history -r;};fi
}
unset IFS
}
