h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
[[ `history|head -1` =~ ^[[:space:]]*([0-9]+) ]]
((B=1+HISTCMD-(OF=BASH_REMATCH[1])))
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
		*)   			read -rei "$m" m; break
		esac
	done
fi
unset IFS b i j k l u Z D E n s t ln
m=${m//\\/\\\\}
eval set -- \"${m//\"/\\\"}\"
i=;for m ;{
 let ++i
 if [[ $m =~ ^-?-?[0-9]+-?[0-9]*$ ]];then n=$m\ $n ;else t=${*:i} ;break;fi
}
set -- $n
for n ;{
 if [[ $n =~ ^([0-9]+)(-([1-9][0-9]*)?)?$ ]];then
  let l=u=BASH_REMATCH[1]
  ((l<OF)) &&{ echo $l is less than history start $OF, changed to be it;l=$OF;}
  ((l=u=l?l:1))
  [[ ${BASH_REMATCH[2]} ]] && u=${BASH_REMATCH[3]:-$HISTCMD}
  ((u<l)) &&{ t=$u;u=$l;l=$t; }
  ((u>HISTCMD)) &&{ echo $l-$u is invalid number range;continue;}
  for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null
  }
  echo -en "\e[41;1;37mDeleted line $l ";((u>l)) && echo -en to line $u;echo -e '\e[m';did=1
  ((LO=1+HISTCMD-l+((lo=l>13? 13: l))))
  history $LO | head -$lo
  echo -e "  \e[1;32m   The deletion by line number $n was here.......\e[m"
  ((H=1+HISTCMD-l))
  history $H | head -$((H>13? 13: H))
 else
  [[ $n =~ ^-([1-9][0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]]
  ((e=BASH_REMATCH[3] ? ${BASH_REMATCH[4]:-1}+1 :1))
  echo -en '\e[41;1;37m'
  if((d=BASH_REMATCH[2])) ;then
   ((l=1+HISTCMD-((D=d+U))))
   ((e>=d)) &&{ echo $e: invalid value, use a dash such -$d to delete line $l only;set --;continue;}
   echo -e Deleted the last $d lines but the last $((e-1)) i.e. lines $l-$((u=1+HISTCMD-((E=e+U))))'\e[m'
  else
   ((d=${BASH_REMATCH[1]:-1}))
   echo -e Deleted the line $d from the latest i.e. line $((u=l=1+HISTCMD-((E=D=d+U))))'\e[m'
  fi
  ((d>25)) || ((D>B)) &&{ echo $d: out of list range;set --;continue;}
  for i in `eval echo {$D..$E}`
  {
   history -d -$i 2>/dev/null
  };did=1
  ((LO=1+HISTCMD-l+((lo=l>13? 13: l))))
  history $LO | head -$lo
  echo -e "  \e[1;32m   Some line(s) deleted by $n was/were here.......\e[m"
  ((H=1+HISTCMD-l))
  history $H | head -$((H>13? 13: H))
 fi
}
[[ $t ]] &&{
 s=${t//\//\\/};s=${s//\*/\\*};s=${s//.../.*}
 s=${s//\+/\\+};s=${s//\|/\\|};s=${s//\^/\\^};s=${s//\?/\\?};
 s=${s//\[/\\[};s=${s//\(/\\(};s=${s//\{/\\{}
 s=${s//\]/\\]};s=${s//\)/\\)};s=${s//\}/\\'}'}
 s=${s//\$/\\\$}
 if((${#t}>2)) ;then
  if [[ $s =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then s=.*$s.*
  elif [[ $s =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then s=${BASH_REMATCH[1]}.*
  elif [[ $s =~ ^([[:graph:]].*)[[:space:]]+$ ]] ;then	s=.*${BASH_REMATCH[1]}
  elif [[ $s =~ ^[[:space:]](.*)[[:space:]]+$ ]] ;then	s=${BASH_REMATCH[1]};fi
 elif [[ $s =~ ^[[:space:]](.*)[[:space:]]+$ ]] ;then	s=.*${BASH_REMATCH[1]}.*
 fi
 IFS=$'\n'
 for h in `history|sed -nE "s/^\s+([0-9]+)\*?\s+($s)$/\1-\2/p"`
 {
  [[ $h =~ ^([0-9]+)-(.+) ]]
  let ln[Z]=BASH_REMATCH[1]
  printf "% 5d" ${ln[Z]};echo -en ' \e[41;1;37m';echo -n ${BASH_REMATCH[2]};echo -e '\e[m'
  ((Z++)) || l=$ln
 }
 ! ((Z)) &&{ echo -e "\e[41;1;37m$t\e[m wasn't found, did nothing";set --;continue;}
 echo -en '\e[40;1;32m'
 read -N1 -p "Delete $Z line(s) above from command history? (Enter: yes Else: no) " h
 let u=ln[--Z]
 [[ $h = $'\xa' ]] ||{ echo;set --;continue;}
 unset IFS
 for ((i=Z; i>=0; i--)){
  history -d ${ln[i]} 2>/dev/null
  let u-- ;}
 echo -e "Finished deleting $((Z+1)) lines all above \e[m";did=1
 ((LO=1+HISTCMD-l+((lo=l>13? 13: l))))
 history $LO | head -$lo
 echo -e "  \e[1;32m   Some line(s) deleted having string \e[41m$t\e[40m was/were here.......\e[m"
 ((H=1+HISTCMD-u))
 history $H | head -$((H>13? 13: H))
}
((F))&&break
set --
done
((did)) &&{
 read -sN1 -p 'Save the modified history (Enter: yes)? ' o
	if [[ $o = $'\xa' ]];then
  history -w&&echo ..saved
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&	history -d $((BASH_REMATCH[1]-i++)); }
	else
		read -N1 -p ' Revert back the modified history (Enter: yes)? ' o
		[ "$o" = $'\xa' ]&&{ history -c;history -r;}
 fi
}
unset IFS
} #END h
