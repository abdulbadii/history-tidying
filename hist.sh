h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
G=1;[[ $1 ]] ||{
 G=;L=25;U=0;i=;did=
 IFS=$'\n';for e in `history 25` ;{
  if((i++%5)) ;then echo $e
  else echo $'\e[44;1;37m'$e$'\e[m';fi;}
}
while : ;do
unset IFS i s
if((G));then m=$*
else
 [[ `history|head -1` =~ ^[[:space:]]+([0-9]+) ]];((B=1+HISTCMD-(OF=BASH_REMATCH[1])))
 while : ;do
 	u=;IFS=''
  read -sN1 -p "`echo $'\r\e[K\e[45;1;37m'`Up/Down. n[=-n] by line or else string: " m;echo -n $'\e[m'
		case $m in
		$'\x1b') # \e ESC
			read -N 1 m
			if [[ $m != [ ]] ;then return
			else
				read -N 1 m; echo
   	IFS=$'\n'
				case $m in
				A) #UP
     U=$L
					if((((L+=25))>B)) ;then
						let L-=B
						for e in `history $L;history |head -$((25-L))` ;{
       if((i++%5)) ;then echo $e
       else echo $'\e[44;1;37m'$e$'\e[m';fi;}
					else
    		for e in `history $L | head -25`;{
       if((i++%5)) ;then echo $e
       else echo $'\e[44;1;37m'$e$'\e[m';fi;}   
					fi;;
				B) #DN
     L=$U
					((((U-=25))<0)) &&{ u=`history| head $U`;	let U+=B;}
     for e in `history $L | head -25` $u;{
      if((i++%5)) ;then echo $e
      else echo $'\e[44;1;37m'$e$'\e[m';fi;}
				esac
			fi;;
		$'\xa')	echo;break 2;;
		*) read -rei "$m" m; break
		esac
	done
fi
if [[ \ $m =~ ^((\ +[0-9]+(-[0-9]+|=-?[0-9]*)?|\ +-[1-9][0-9]*(=-?[0-9]*)?|\+ -|\ +--[1-9][0-9]*-?[0-9]*)+)(\ (.*))?$ ]];then
 for Z in ${BASH_REMATCH[1]} ;{ s=$Z\ $s ;}
 Z=${BASH_REMATCH[6]}
 [[ $Z ]]&&echo -e "Try to find line: $s\nAlso one with string $Z"
else Z=$m
fi
eval set -- $s
for n ;{ unset e i j k l u s z M R F
 [[ $n != $1 ]] && echo -e '\e[40;1;32mThen...\e[m'
 if [[ $n =~ ^([0-9]+)((=-?|-)([0-9][0-9]*)?)?$ ]];then
  ((u=l=(l=BASH_REMATCH[1])? l:1))
  [[ ${BASH_REMATCH[2]} ]] &&{ u=${BASH_REMATCH[4]}
   if [ ${BASH_REMATCH[3]} = - ] ;then
    : ${u:=$HISTCMD}; ((u=u?u:1))
   else ((u=${BASH_REMATCH[3]#=}(u=u?u:1)+l)) ;fi
  }
  ((u<l)) &&{ T=$u;u=$l;l=$T; }
  ((u>HISTCMD)) || ((l<OF)) &&{ echo the history starting-end line numbers: $OF-$HISTCMD;continue;}
  ((l<(d=1+HISTCMD-L))) &&{
   ((u==l)) &&{ echo line number $l out of the list;continue;}
   ((l<d-17)) &&{ echo $l is 17 less than the min line $d shown;continue;};}
  ((u>(e=HISTCMD-U))) &&{
   ((u==l)) &&{ echo line number $u out of the list;continue;}
  ((u>e+17)) &&{ echo $u is 17 more than the max line $e shown;continue;};}
  IFS=$'\n'
  for i in `history $((1+HISTCMD-l)) | head -$t`;{
   [[ $i =~ ^[[:space:]]+([0-9]+).(.+) ]]
   printf "\e[41;1;37m% 4d\e[m%s\n" ${BASH_REMATCH[1]} "${BASH_REMATCH[2]}"
  }
  echo -en '\e[1;32m';read -N1 -p "Delete $t line$s above from command history? (Enter: yes Else: no) " o
  [[ $o = $'\xa' ]] ||{ continue;}
  history -w /tmp/.bash_history0 ||{
   echo cannot backup current history for reverting later;R=1;}
  unset IFS;for i in `eval echo {$u..$l}` ;{
   history -d $i 2>/dev/null;};did=1
  n=$l; b='line was'
  ((l!=u)) &&{
   n=$l-$u; b="$((t=u-l+1)) lines were";s=s ;}
 else
  [[ $n =~ ^-([1-9][0-9]*)?(=-?[0-9]*)?$|^--([1-9][0-9]*)(-([1-9][0-9]*)?)?$ ]]
  if((d=BASH_REMATCH[3])) ;then
   [[ ${BASH_REMATCH[4]} ]] && e=${BASH_REMATCH[5]:-1}
   ((e++>d)) || ((d>25)) &&{ echo $n: invalid range;continue;}
  else
   ((e=d=(d=BASH_REMATCH[1])?d:1))
   t=${BASH_REMATCH[2]}
   [[ $t ]] &&{
    t=${t#=};tt=${t#-}; ((tt)) ||{ tt=1;t=${t}1 ;}
    (((d-=t)<e)) &&{ T=$d;d=$e;e=$T; }
   }
   ((e==d))&&((d>25))&&{ echo $d is beyond the max 25 lines shown;continue;}
   ((d>25+17))||((e<-17))&&{ echo line number $t span to 17 lines beyond the min/max line shown;continue;}
  fi
  ((l=1+HISTCMD-((D=d+U))));let E=e+U
  u=;b='line was'
  ((t)) &&{ let u=-l-t; b="$((++tt)) lines were";s=s ;}
  ((E<=0)) &&{ ((k=-(--E))); j=`history |head $E` ;}
  IFS=$'\n';for i in `history $D | head -$tt` $j;{
   [[ $i =~ ^[[:space:]]+([0-9]+).(.+) ]]
   printf "\e[41;1;37m% 4d\e[m%s\n" ${BASH_REMATCH[1]} "${BASH_REMATCH[2]}"
  }
  echo -en '\e[1;32m';read -N1 -p "Delete $tt line$s above from command history? (Enter: yes. Else: no) " o
  [[ $o = $'\xa' ]] ||{ continue;}
  history -w /tmp/.bash_history0||{
   echo cannot backup current history for reverting later;R=1;}
  M="\e[40;1;32m as specified by \e[41;1;37m$n"
  n=$l$u
  unset IFS;for i in `eval echo {$D..$E}` ;{ history -d -$i 2>/dev/null;}
  ((k)) &&{ for((i=k; i>0; --i)){ history -d $i 2>/dev/null;}; n=$l-1-$k;}
  did=1
 fi
 echo -e "\e[1;32mThe $b deleted\e[m"
 L=;let F=l-1
 ((l>11)) &&{ let L=HISTCMD-l+12 ; F=11 ;}
 ((l<12)) && history $((11-F))
 history $L | head -$F
 echo -e "  \e[1;32m Here's where the found, deleted $b, previously line \e[41;1;37m$n$M\e[m"
 ((H=1+HISTCMD-(k?1:l)))
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
 S=${Z# }; S=${S% }
 if((${#S}>2)) ;then
  if [[ $s =~ ^[[:space:]]+(.*[[:graph:]])$ ]] ;then s="()(${BASH_REMATCH[1]})(.*)"
  elif [[ $s =~ ^([[:graph:]].*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="()(${BASH_REMATCH[1]})()"
  elif [[ $s =~ ^[[:graph:]].*[[:graph:]]$ ]] ;then s="(.*)($s)(.*)";fi
 elif [[ $s =~ ^[[:space:]](.*)[[:space:]]$ ]] ;then	s="(.*)(${BASH_REMATCH[1]})(.*)";fi
 IFS=$'\n'
 for h in `history |sed -nE "/^\s+[0-9]+\*?\s+$s$/p"`;{
  [[ $h =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]+$s ]]
  printf "\e[1;36m% 4d \e[m%s\e[41;1;37m%s\e[m%s\n" $((l[z++]=BASH_REMATCH[1])) "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}"
 }
 ((z)) ||{ echo -e "\e[41;1;37m$Z\e[m wasn't found, did nothing";continue;}
 ((u=-z+(H=l[--z]))) # l = l[0]
 if ((z)) ;then
  b='lines were'
  ((H-l>z)) &&M=", not consecutive between which the undeleted lines lie";s=s
 else b='line was';s=;fi
 echo -en '\e[1;32m'
 read -N1 -p "Delete $((z+1)) line$s above from command history? (Enter: yes. Else: no) " o
 [[ $o = $'\xa' ]] ||{ continue;}
 history -w /tmp/.bash_history0||{
   echo cannot backup current history for reverting later;R=1;}
 for ((i=z; i>=0; i--)){
  history -d ${l[i]} 2>/dev/null ;};did=1
 echo -e "Finished, the $((z+1)) $b deleted\e[m"
 L=;let F=l-1
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
