h(){ # BEGIN h
[[ $1 =~ ^-cr|^-rc ]] &&{ history -c;history -r;return;}
[[ $1 =~ ^--help$|^-[anprswdc]$|^\. ]] &&{ history ${@#.};return;}
FG=1
[[ $1 ]] ||{ unset FG i did U;L=25;IFS=$'\n'
 for e in `history 25`;{ ((i++%5)) ||echo -ne '\e[1;32m'; echo $e$'\e[m';}
}
while :;do IFS=$'\n'
unset s Z
if((FG));then m=$* # by CLI argument
else
 [[ `history|head -1` =~ ^[[:space:]]+([0-9]+) ]]
 (((H=1+HISTCMD-(OF=BASH_REMATCH[1]))<3))&&{ echo too few history lines;return;}
 while :;do
  read -sN1 -p "`echo $'\r\e[K\e[44;1;37m'`Up/Down, n[=-n] by line, else string: " m;echo -n $'\e[m'
		case $m in
		$'\x1b') # \e
			read -N1 m
				read -N1 m;echo;i=;j=
				case $m in
				A) #UP
     ((U=L==H? 0: L))
     (((L+=25)>H)) &&{ let L-=H; j=`history|head -$((25-L))`;};;
				B) #DN
     (((U=(L=U?U:H)-25)<0)) &&{ j=`history|head $U`;	let U+=H;}
				esac
    for e in `history $L |head -25` $j;{ ((i++%5)) ||echo -ne '\e[1;32m'; echo $e$'\e[m';};;
		$'\xa')	echo;break 2;;
  $'\x7f')
   echo -e '\r\e[K\e[44;1;37mreadline input\e[m'; read -re Z;Z=$Z\ ;break;;
  *) read -rei "$m" m; break
		esac
	done
fi
[[ $Z ]] ||{
 if [[ \ $m =~ ^((\ +[1-9][0-9]*(=?-?([1-9][0-9]*)?)?|\ +-[1-9][0-9]*(=-?[0-9]*)?|\ +-|\ +--([1-9][0-9]*)?-?[0-9]*)+)(\ (.*))?$ ]]
 then
  s=${BASH_REMATCH[1]};Z=${BASH_REMATCH[8]}
  [[ $Z ]]&&echo -e "Finding line: $s... Also one with string\n$Z"
 else Z=$m;fi
}
unset C P TL W
eval set -- $s
((N=25/3/((NE=${#*})? NE: 1)))
for a ;{ unset i j k mm e l u t z LO HI W
 [[ $a != $1 ]] &&echo -en '\e[37;1;32m*\e[m'
 ((M=HISTCMD-U,m=1+HISTCMD-L))   # Max & min shown
 if [[ $a =~ ^([1-9][0-9]*)(=-?|-)?([1-9][0-9]*)?$ ]];then
  let l=u=BASH_REMATCH[1]
  [[ ${BASH_REMATCH[2]} ]] &&{ u=${BASH_REMATCH[3]}
   if [ ${BASH_REMATCH[2]} = - ] ;then : ${u:=$M}; ((l>u)) &&let l-=HISTCMD
   else ((u=l+${BASH_REMATCH[2]#=}(z=u?u:1))) ;fi
  }
 else
  if [[ $a =~ ^--([1-9][0-9]*)?(-([1-9][0-9]*)?)?$ ]] ;then
   [[ ${BASH_REMATCH[2]} ]] &&
    e=${BASH_REMATCH[3]:-1}
   ((e>=(d=(d=BASH_REMATCH[1])?d:25))) ||((d>25)) &&{ echo $a: invalid range;continue;}
   let z=d-e-1
  elif [[ $a =~ ^-([1-9][0-9]*)?(=-?[0-9]*)?$ ]] ;then
   ((d=(d=BASH_REMATCH[1])?d:1))
   t=${BASH_REMATCH[2]}
   [[ $t ]] &&{ t=${t#=};z=${t#-}; ((z=z?t:${t}1)) ;}
  fi
  ((u=z+(l=(l=1+M-d)<0? HISTCMD+l: l))); z=${z#-}
  mm=" as specified `echo $'\e[41;1;37m'$a`"
 fi
 ((m<M)) && (((l<m)) || ((l>M))) ||
 (((m>M)) && ((l<m)) && ((l>M))) &&{ echo $l is beyond the min/max line shown;continue;}
 ((m<M)) && (((u<m-9)) || ((u>M+9))) ||
 (((m>M)) && ((u<m-9)) && ((u>M+9))) &&{ echo $u is 9 lines beyond the min/max line shown;continue;}
 ((u<l)) &&{ T=$l;l=$u;u=$T ;}
 s=history\ $((1+HISTCMD-l))
 if((l==u));then
  z=1;s="$s|head -1"; p=\ was;n=$l
 else
  ((z=z?1+z:u-l+1))
  if((l<=0)) ;then
   ((m>M)) &&((l+HISTCMD-m+9<0)) &&{ echo $l is 9 or more lines below the min $m shown;continue;}
   s=history\ $((W=-l+1))
   i="|head -$((W+u))"
   ((u>0)) &&{ i=;j='history|head -$u'; k=,1-$u;}
   s=$s$i\;$j
   n=$((t=HISTCMD+l))-$((HISTCMD-(u>0?0:u)))$k
   LO={$HISTCMD..$t}; HI={$u..1}
  elif((u>HISTCMD)) ;then
   ((m>M)) && ((u>HISTCMD+M+9)) &&{ echo $u is 9 or more lines above the max $M shown;continue;}
   (((W=HISTCMD-u)==-1)) &&W=
   n=$l-$HISTCMD,1$W
   ((l>HISTCMD)) &&{ n=$((l-HISTCMD))$W; s=:; ((i=1+2*HISTCMD-l,W=l-u-1));}
   s="$s; history $i |head $W"
   LO={$HISTCMD..$l}; HI={${W#-}..1}
  else
   s="$s|head -$z";n=$l-$u
  fi
  p=s\ were; n="$n ($z lines)"
 fi
 IFS=$'\n';for i in `eval $s`;{
  [[ $i =~ ^[[:space:]]+([0-9]+).(.+) ]]
  printf "\e[41;1;37m% 4d\e[m%s\n" ${BASH_REMATCH[1]} "${BASH_REMATCH[2]}";}
 P="\''<---- the deleted line$p here: `echo $'\e[41;1;37m'$n$'\e[40;1;32m'$mm$'\e[m'`'\'"
 let TL+=z
 ((W)) &&continue
 C="{$u..$l} $l$P $C"   # Join range entries with "$l<" token
}
((W))&& C="$LO $C $HI 1$P"
((To=TO=2*NE*(N+1)-2))
((TL)) &&{
unset IFS s h LN R
if((TL==1)) ;then TL=\ above
else TL=se\ $TL;s=s;fi
echo -en '\e[1;32m';read -sN1 -p "Delete the$TL line$s? (Enter: yes. Else: no) " o;echo -en '\e[m'
[[ $o = $'\xa' ]] ||continue
history -w /tmp/.bash_history0||{ echo cannot backup current history for reverting later;R=1;}
eval set -- `eval echo $C`
for e;{
 history -d $e 2>/dev/null ||{ IFS=$'\n'
  ((i=(To-=2*N)));l=${e%<*}
  H=;L=$HISTCMD;let h=l-1
  if((l>N)) ;then let L+=1-l+N; h=$N
  else for j in `history $((N-h))`;{ LN[i++]=$j ;}
  fi
  for j in `history $L |head -$h`;{ LN[i++]=$j ;}
  LN[i++]=" `echo $'\e[1;32m'${e#$l}`"
  ((U=(H=W? HISTCMD: 1+HISTCMD-l)>N? N: H))
  ((H)) &&for j in `history $H |head -$U`;{ LN[i++]=$j ;}
  let U=H-U
  ((H<=N)) &&{
   let U=N-H
   for j in `history |head -$U`;{ LN[i++]=$j ;}
   let U=HISTCMD-U
  }
  let To-=2;LN[i++]='            ~~~~~~~'
 }
}
echo "...deleted";did=1
for((j=0;j<=TO;)){ echo ${LN[j++]} ;}
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
 fi
 z=;for i in `history |sed -nE "/^\s+[0-9]+\*?\s+$s$/p"`;{
  [[ $i =~ ^[[:space:]]+([0-9]+)\*?[[:space:]]+$s ]]
  printf "\e[1;36m% 4d \e[m%s\e[41;1;37m%s\e[m%s\n" $((l[z++]=BASH_REMATCH[1])) "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[4]}"
 }
 ((z)) ||{ echo -e "\e[41;1;37m$Z\e[m wasn't found, did nothing";continue;}
 ((u=-z+(H=l[--z]))) # l = l[0]
 m='line'; s='was'
 ((z))&&{ m="$((z+1)) lines"; s='were'
  ((H-l>z)) && P=", interlined with the undeleted lines,"
 }
 echo -en '\e[1;32m';read -N1 -sp "Delete the $m above from command history? (Enter: yes. Else: no) " o
 echo -en '\e[m';[[ $o = $'\xa' ]] ||continue
 history -w /tmp/.bash_history0||{ echo cannot backup current history for reverting later;R=1;}
 for((i=z;i>=0;)){ history -d ${l[i--]} ;};did=1;echo ...deleted
 L=;let F=l-1
 if((l>N)) ;then let L=1+HISTCMD-l+N; F=$N
 else history $((N-F));fi
 history $L | head -$F
 echo -e "  \e[40;1;32m<-- The $m deleted $s here$P as search for \e[41;1;37m$Z\e[m"
 let H=HISTCMD-u
 ((U=H>N? N: H))
 ((H)) && history $H |head -$U
 let U=H-U
 ((H<=N)) &&{ let U=N-H
  history |head -$U
  let U=HISTCMD-U;}
}
((FG))&&break
done
((did)) &&{ s=
 ((R)) ||s='. Else: No, revert back'
 read -sN1 -p "Save the modified history? (Enter: Yes. N/n: No$s) " o
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
