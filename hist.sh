h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
G=1;L=25;U=0;did=
while : ;do
if [ -z "$1" ] ;then
	((G))&&{	history 25;G=;	 }
 [[ `history|head -1` =~ ^[[:space:]]+([0-9]+) ]];((B=1+HISTCMD-(OF=BASH_REMATCH[1])))
	IFS='';while : ;do
		read -sN 1 -p "`echo -e '\r\e[44;1;37m'`Next 25? Up/Down: to older/newer, [-|--]n[=|-n] erase by range, Enter: out, Else: a search string `echo $'\e[m\n\r'`" m
		case $m in
		$'\x1b') # \e ESC
			read -N 1 m
   if [[ $m = ' ' ]] ;then read -re m; history -s $m;return
			elif [[ $m != [ ]] ;then return
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
		*) read -rei "$m" m; break
		esac
	done
else m=$*
fi
unset IFS l u z s
if [[ $m =~ ^(([0-9]+(-[0-9]+|=-?[0-9]*)?|-[1-9][0-9]*(=-?[0-9]*)?|-|--[1-9][0-9]*-?[0-9]*)(\ +[0-9]+(-[0-9]+|=-?[0-9]*)?|\ +-[1-9][0-9]*(=-?[0-9]*)?|\+ -|\ +--[1-9][0-9]*-?[0-9]*)*)(\ +(.*))?$ ]];then
 for Z in ${BASH_REMATCH[1]} ;{ s=$Z\ $s ;}
 Z=${BASH_REMATCH[9]}
 [[ $Z ]]&&echo -e Try to find, delete line: $s\nAlso one with string $Z
else Z=$m
fi
set -- $s
for n ;{ unset ln M R s
 [[ $n != $1 ]] && echo -e '\e[40;1;32mThen...\e[m'
 if [[ $n =~ ^([0-9]+)((=-?|-)([0-9][0-9]*)?)?$ ]];then
  let l=BASH_REMATCH[1]
  ((u=l=l?l:1))
  [[ ${BASH_REMATCH[2]} ]] &&{ u=${BASH_REMATCH[4]}
   if [ ${BASH_REMATCH[3]} = - ] ;then
    : ${u:=$HISTCMD}; ((u=u?u:1))
   else ((u=${BASH_REMATCH[3]#=}(u=u?u:1)+l)) ;fi
  }
  ((u<l)) &&{ T=$u;u=$l;l=$T; }
  ((u>HISTCMD)) || ((l<OF)) &&{ echo the history starting-end line numbers are $OF-$HISTCMD;continue;}
  ((l<(d=1+HISTCMD-L)-17)) &&{ echo $l is 17 less than the min line $d shown;continue;}
  ((u>(e=HISTCMD-U)+17)) &&{ echo $u is 17 more than the max line $e shown;continue;}
  n=$l; b='line was'
  ((l!=u)) &&{
   n=$l-$u; b="$((t=u-l+1)) lines were"s=s ;}
  IFS=$'\n'
  for i in `history $((1+HISTCMD-l)) | head -$t`;{
   [[ $i =~ ^[[:space:]]+([0-9]+).(.+) ]]
   printf "\e[41;1;37m% 4d\e[m%s\n" ${BASH_REMATCH[1]} "${BASH_REMATCH[2]}"
  }
  echo -e '\e[1;32m';read -N1 -p "Delete $t line$s above from command history? (Enter: yes Else: no) " o
  [[ $o = $'\xa' ]] ||{ continue;}
  history -w /tmp/.bash_history0 ||{
   echo cannot backup current history for reverting later;R=1;}
  unset IFS;for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null;};did=1
 else
  [[ $n =~ ^-([1-9][0-9]*)?(=-?[0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]]
  if((d=BASH_REMATCH[3])) ;then
   [[ ${BASH_REMATCH[4]} ]] && e=${BASH_REMATCH[5]:-1}
   ((e>=d-1)) &&{ echo $e: invalid use, do -$d to delete only line $l;continue;}
   let ++e
  else
   ((e=d=(d=BASH_REMATCH[1])?d:1))
   [[ ${BASH_REMATCH[2]} ]] &&{ t=${BASH_REMATCH[2]#=}
    ((${t#-})) ||t=${t}1
    (((d-=t)<e)) &&{ T=$d;d=$e;e=$T; }
   }
  fi  
  ((e<-17))||((d>25+17)) &&{ echo number of lines $t span to 17 lines beyond the min/max line shown;continue;}
  ((D>B)) &&{ echo $d or $e: out of list range;continue;}
  ((l=1+HISTCMD-((D=d+U))));let E=e+U
  ((t=d-e))
  u=;b='line was'
  ((t++)) &&{ let u=-l-t; b="$t lines were";s=s ;}
  IFS=$'\n'
  for i in `history $D | head -$t`;{
   [[ $i =~ ^[[:space:]]+([0-9]+).(.+) ]]
   printf "\e[41;1;37m% 4d\e[m%s\n" ${BASH_REMATCH[1]} "${BASH_REMATCH[2]}"
  }
  echo -e '\e[1;32m';read -N1 -p "Delete $t line$s above from command history? (Enter: yes Else: no) " h
  [[ $h = $'\xa' ]] ||{ continue;}
  history -w /tmp/.bash_history0||{
   echo cannot backup current history for reverting later;R=1;}
  unset IFS;for i in `eval echo {$D..$E}` ;{
   history -d -$i 2>/dev/null;};did=1
  M="\e[40;1;32m as specified by \e[41;1;37m$n"
  n=$l$u
 fi
 echo -e "\e[1;32mThe $b deleted\e[m"
 L=;let F=l-1
 ((l>11)) &&{ let L=HISTCMD-l+12 ; F=11 ;}
 ((l<12)) && history $((11-F))
 history $L | head -$F
 echo -e "  \e[1;32m Here's where the found, deleted $b, previously line \e[41;1;37m$n$M\e[m"
 l=$l
 let H=1+HISTCMD-l
 ((U=H>11? 11: H))
 ((H)) && history $H |head -$U
 let U=H-U
 ((H<12)) &&{ let U=11-H; history |head -$U;let U=HISTCMD-U;}
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
 ((z)) ||{ echo -e "\e[41;1;37m$Z\e[m wasn't found, did nothing";continue;}
 echo -en '\e[40;1;32m'
 ((u=-z+((H=ln[--z]))))
 if ((z)) ;then
  b='lines were';s=s
  ((H-l>z)) && M=", not consecutive between which the undeleted lines lie"
 else b='line was';s=
 fi
 read -N1 -p "Delete $((z+1)) line$s above from command history? (Enter: yes Else: no) " h
 [[ $h = $'\xa' ]] ||{ continue;}
 history -w /tmp/.bash_history0||{
   echo cannot backup current history for reverting later;R=1;}
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
 ((R)) ||s='. Else: No, revert back'
 read -sN1 -p "Save the modified history (Enter: Yes. N/n: No$s)? " o
	if [[ $o = $'\xa' ]];then
  IFS=$'\n';i=;for l in `history`
  {	[[ $l =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]*$ ]] &&history -d $((BASH_REMATCH[1]-i++)); }
  history -w&&echo ..saved
	else
  ((R)) || [[ ! $o =~ ^[nN]$ ]] &&{ history -c;history -r /tmp/.bash_history0;}
  echo $o
 fi
};unset IFS
}
