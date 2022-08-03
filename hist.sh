h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
F=1;L=25;U=0;did=
while : ;do
if [ -z "$1" ] ;then
	((F))&&{	history 25;F=;	 }
 [[ `history|head -1` =~ ^[[:space:]]+([0-9]+) ]];((B=1+HISTCMD-(OF=BASH_REMATCH[1])))
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Next 25? Up/Down: from last/begin, [-]n[-][n] erase by range, Enter: out, Else: as substring `echo -e '\e[m\n\r'`" m
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
						let U+=B ;}
				esac
			fi;;
		$'\xa')	break 2;;
		*)   			read -rei "$m" m; break
		esac
	done
 unset IFS b i j k l u Z D E n s t ln
fi
if [[ $m =~ ^(-?-?[0-9]+-?[0-9]*(\ +-?-?[0-9]+-?[0-9]*)*)(.*) ]];then
 for m in ${BASH_REMATCH[1]} ;{ n=$m\ $n ;}
 t=${BASH_REMATCH[3]}
else t=$m
fi
t="${t//\\/\\\\}";t=${t//\\\\./\\.}
set -- $n
for n ;{
 [[ $n != $1 ]] && echo -e '\e[40;1;32mThen:\e[m'
 if [[ $n =~ ^([0-9]+)(-([1-9][0-9]*)?)?$ ]];then
  let l=u=BASH_REMATCH[1]
  ((l<OF)) &&{ echo $l is less than history start $OF, give it as $OF;l=$OF;}
  ((l=u=l?l:1));be='line was'
  [[ ${BASH_REMATCH[2]} ]] &&{
   u=${BASH_REMATCH[3]:-$HISTCMD}
   be="$((u-l+1)) lines were"
  }
  ((u<l)) &&{ t=$u;u=$l;l=$t; }
  ((u>HISTCMD)) &&{ echo $u is beyond range;continue;}
  echo -en '\e[41;1;37m';history $((1+HISTCMD-l)) | head -$((u-l+1));echo -en '\e[m'
  for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null
  };did=1
 else  e=
  [[ $n =~ ^-([1-9][0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]]
  if((d=BASH_REMATCH[2])) ;then
   ((BASH_REMATCH[3])) && e=${BASH_REMATCH[4]:-1}
   ((l=1+HISTCMD-((D=d+U))))
   ((e>=d-1)) &&{ echo $e: invalid value, use a dash such -$d to delete line $l only;set --;continue;}
   let s=d-e++ ;let E=e+U
   be="$((D-E+1)) lines were"
  else
   ((d=${BASH_REMATCH[1]:-1}))
   ((l=1+HISTCMD-((E=D=d+U))))
   s=1;be='line was'
  fi
  ((d>25)) || ((D>B)) &&{ echo $d: out of list range;set --;continue;}
  echo -en '\e[41;1;37m'; history $d | head -$s ;echo -en '\e[m'
  for i in `eval echo {$D..$E}`
  {
   history -d -$i 2>/dev/null
  };did=1
 fi
 echo -e "\e[1;32mThe $be deleted\e[m"
 ((L=LO=1+HISTCMD-l+((lo=l>11? 11: l))))
 history $LO | head -$lo
 echo -e "  \e[1;32m   ...Here's where the found, deleted $be, by finding \e[41;1;37m$n\e[m"
 ((H=1+HISTCMD-l))
 ((U=H>11? -11: -H));history $H |head $U
 let U+=H
}
[[ $t ]] &&{ M=
 s=${t//\"/\\\"};s=${s//\//\\/};s=${s//\*/\\*};s=${s//.../.*}
 s=${s//\+/\\+};s=${s//\|/\\|};s=${s//\^/\\^};s=${s//\?/\\?};
 s=${s//\[/\\[};s=${s//\(/\\(};s=${s//\{/\\{}
 s=${s//\]/\\]};s=${s//\)/\\)};s=${s//\}/\\'}'}
 s=${s//\$/\\\$}
 if((${#t}>2)) ;then
  if [[ $s =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then s="()(${BASH_REMATCH[1]})(.*)"
  elif [[ $s =~ ^([[:graph:]].*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="()(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then s="(.*)($s)(.*)";fi
 elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})(.*)";fi
 IFS=$'\n'
 for h in `history |sed -nE "/^\s+[0-9]+\*?\s+$s$/p"`
 {
  [[ $h =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]+$s ]]
  printf "\e[1;36m% 4d \e[m%s\e[41;1;37m%s\e[m%s\n" $((ln[Z]=BASH_REMATCH[1])) "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}"
  ((Z++)) || l=$ln
 }
 ! ((Z)) &&{ echo -e "\e[41;1;37m$t\e[m wasn't found, did nothing";set --;continue;}
 echo -en '\e[40;1;32m'
 ((u=-Z+((H=ln[--Z]))))
 if ((Z)) ;then
  be='lines were';s=s
  ((H-l>Z)) && M=", being not consecutive between which the undeleted lines lie"
 else be='line was';s=;fi
 read -N1 -p "Delete $((Z+1)) line$s above from command history? (Enter: yes Else: no) " h
 [[ $h = $'\xa' ]] ||{ echo;set --;continue;}
 for ((i=Z; i>=0; i--)){
  history -d ${ln[i]} 2>/dev/null ;};did=1
 echo -e "Finished, the $((Z+1)) $be deleted\e[m"
 ((L=LO=1+HISTCMD-l+((lo=l>11? 11: l))))
 history $LO | head -$lo
 echo -e "\e[40;1;32m   ...Here's where the found, deleted $be$M, as searched by string \e[41;1;37m$t\e[m"
 ((H=HISTCMD-u))
 ((U=H>11? -11: -H));history $H |head $U
 let U+=H
}
((F))&&break
set --
done
((did)) &&{
 read -N1 -p 'Save the modified history (Enter: Yes. R/r: No, revert back the deletion. Else: No)? ' o
	if [[ $o = $'\xa' ]];then
  history -w&&echo -n ..saved
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&history -d $((BASH_REMATCH[1]-i++)); }
	elif	[[ $o =~ ^[rR]$ ]] ;then history -c;history -r;fi;echo
}
unset IFS
} #END h
