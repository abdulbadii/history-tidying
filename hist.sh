h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
G=1;L=25;U=0;did=
while : ;do
if [ -z "$1" ] ;then
	((G))&&{	history 25;G=;	 }
 [[ `history|head -1` =~ ^[[:space:]]+([0-9]+) ]];((B=1+HISTCMD-(OF=BASH_REMATCH[1])))
	IFS='';while : ;do
		read -sN 1 -p "`echo $'\e[44;1;37m'`Next 25? Up/Down: to older/newer, [-|--]n[=|-n] erase by range, Enter: out, Else: a search string `echo -e '\e[m\n\r'`" m
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
						history $L
						history |head $((L-25))
					else
						history $L| head -25
					fi;;
				B) #DN
     L=$U
					history $U	| head -25
					((((U-=25))<0)) &&{
						history| head $U
						let U+=B ;}
				esac
			fi;;
		$'\xa')	break 2;;
		*)   			read -rei "$m" m; break
		esac
	done
else m=$*
fi
unset IFS l u z s
if [[ $m =~ ^(([0-9]+(-[0-9]|=-?[0-9]*)?|-([1-9][0-9]*(=-?[0-9]*)?)?|--[1-9][0-9]*-?[0-9]*)+)(\ +(.*))?$ ]];then
 for Z in ${BASH_REMATCH[1]} ;{ s=$Z\ $s ;}
 Z=${BASH_REMATCH[7]}
 [[ $Z ]]&&echo -e Try to find, delete line: $s\nAlso one with string $Z
else Z=$m
fi
set -- $s
for n ;{ unset ln e R
 [[ $n != $1 ]] && echo -e '\e[40;1;32mThen...\e[m'
 if [[ $n =~ ^([0-9]+)((=-?|-)([0-9][0-9]*)?)?$ ]];then
  let l=BASH_REMATCH[1]
  ((l=l?l:1))
  [[ ${BASH_REMATCH[2]} ]] &&{
   u=${BASH_REMATCH[4]:-$HISTCMD};((u=u?u:1))
   [ ! ${BASH_REMATCH[3]} = - ] &&{
    u=${BASH_REMATCH[2]#=};((${u#-})) ||u=${u}1
    let u+=l;}
  }
  ((u<l)) &&{ T=$u;u=$l;l=$T; }
  ((l<OF)) || ((u>HISTCMD)) &&{
   echo $n is beyond range, the history starting-end line numbers are $OF-$HISTCMD;continue;}
  n=$l-$u
  b="$((u-l+1)) lines were"
  ((l==u)) &&{
   n=$l ; b='line was';}
  echo -en '\e[1;35m';history $((1+HISTCMD-l)) | head -$((u-l+1));echo -en '\e[m'
  for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null;};did=1
 else
  [[ $n =~ ^-([1-9][0-9]*)?(=-?[0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]]
  if((d=BASH_REMATCH[3])) ;then
   [[ ${BASH_REMATCH[4]} ]] && e=${BASH_REMATCH[5]:-1}
   ((e>=d-1)) &&{ echo $e: invalid use, do such -$d to delete line $l only;set --;continue;}
   let ++e
  else
   d=${BASH_REMATCH[1]}
   ((e=d=d?d:1))
   [[ ${BASH_REMATCH[2]} ]] &&{ t=${BASH_REMATCH[2]#=}
    ((${t#-})) ||t=${t}1
    ((R=(d-=t)<=0))
    ((d<e)) &&{ T=$d;d=$e;e=$T; }
   }
  fi  
  ((R)) || ((d>50)) || ((D>B)) &&{ echo $d or $e: out of list range;set --;continue;}
  ((l=1+HISTCMD-((D=d+U))));let E=e+U
  ((((u=-l-d+e))==-l)) &&u=
  if ((s=d-e)) ;then b="$((++s)) lines were"
  else b='line was';s=1
  fi
  echo -en '\e[1;35m'; history $D | head -$s ;echo -en '\e[m'
  history -w /tmp/.bash_history0
  for i in `eval echo {$D..$E}` ;{
   history -d -$i 2>/dev/null
  };did=1
  M="\e[40;1;32m as specified by \e[41;1;37m$n"
  n=$l$u
 fi
 echo -e "\e[1;32mThe $b deleted\e[m"
 L=;let F=l-1
 ((l>11)) &&{ let L=HISTCMD-l+12 ; F=11 ;}
 ((l<12)) && history $((11-F))
 history $L | head -$F
 echo -e "  \e[1;32m Here's where the found, deleted $b, previously line \e[41;1;37m$n$M\e[m"
 let H=1+HISTCMD-l
 ((U=H>11? 11: H))
 ((H)) && history $H |head -$U
 let U=H-U
 ((H<12)) &&{
  let U=11-H; history |head -$U;let U=HISTCMD-U
  }
 M=
}
[[ $Z ]] &&{
 s=${Z//\\/\\\\};s=${s//\\\\./\\.};s=${s//\"/\\\"}
 s=${s//\//\\/};s=${s//\*/\\*};s=${s//.../.*}
 s=${s//\+/\\+};s=${s//\|/\\|};s=${s//\^/\\^};s=${s//\?/\\?};
 s=${s//\[/\\[};s=${s//\(/\\(};s=${s//\{/\\{}
 s=${s//\]/\\]};s=${s//\)/\\)};s=${s//\}/\\'}'};s=${s//\$/\\\$}
 if((${#Z}>2)) ;then
  if [[ $s =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then s="()(${BASH_REMATCH[1]})(.*)"
  elif [[ $s =~ ^([[:graph:]].*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="()(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then s="(.*)($s)(.*)";fi
 elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})(.*)";fi
 IFS=$'\n'
 for h in `history |sed -nE "/^\s+[0-9]+\*?\s+$s$/p"`
 {
  [[ $h =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]+$s ]]
  printf "\e[1;36m% 4d \e[m%s\e[41;1;37m%s\e[m%s\n" $((ln[z]=BASH_REMATCH[1])) "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}"
  ((z++)) || l=$ln
 }
 ((z)) ||{ echo -e "\e[41;1;37m$Z\e[m wasn't found, did nothing";set --;continue;}
 echo -en '\e[40;1;32m'
 ((u=-z+((H=ln[--z]))))
 H=$H
 z=$z
 if ((z)) ;then
  b='lines were';s=s
  ((H-l>z)) && M=", not consecutive between which the undeleted lines lie"
 else b='line was';s=
 fi
 read -N1 -p "Delete $((z+1)) line$s above from command history? (Enter: yes Else: no) " h
 [[ $h = $'\xa' ]] ||{ echo;set --;continue;}
 history -w /tmp/.bash_history0
 for ((i=z; i>=0; i--)){
  history -d ${ln[i]} 2>/dev/null ;};did=1
 echo -e "Finished, the $((z+1)) $b deleted\e[m"
 L=;let F=l-1
 l=$l;u=$u
 ((l>11)) &&{ let L=HISTCMD-l+12 ; F=11 ;}
 ((l<12)) && history $((11-F))
 history $L | head -$F
 echo -e "\e[40;1;32m Here's where the found, deleted $b$M, by search \e[41;1;37m$Z\e[m"
 let H=HISTCMD-u
 ((U=H>11? 11: H))
 ((H)) && history $H |head -$U
 let U=H-U
 ((H<12)) &&{
  let U=11-H; history |head -$U
  let U=HISTCMD-U;}
}
((G))&&break
set --
done
((did)) &&{
 read -sN1 -p 'Save the modified history (Enter: Yes. N/n: No. Else: No and revert back deletion)? ' o
	if [[ $o = $'\xa' ]];then
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&history -d $((BASH_REMATCH[1]-i++)); }
  history -w&&echo -n ..saved
	elif	[[ ! $o =~ ^[nN]$ ]] ;then
  history -c;history -r /tmp/.bash_history0
 fi;echo $o
}
unset IFS
} #END h
