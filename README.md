Click, copy "hist.sh" above, then paste, prepend the Bash functions inside ~/.bashrc file   

Tidying up Bash commands history by having good control in erasing certain line(s) by specific number(s) / range) or by a string segment in a history line.   

simply type h then it'll show first 17 lines of last shell commands e.g:

$ h   
  366  pushd --help
  367  pushd 
  368  pushd -n debian/
  369  pushd  build/
  370  debuild -i -uc -us -b
  371  ls debuild*
  372  ls -hs
  373  cd ../debian/
  357  sudo rm 60\ Ebooks\ That\ Will\ Change\ Your\ Life.zip
  358  cd
  359  cp n.sh .config/autostart-scripts/autostart.sh
  360  rm .config/autostart-scripts/autostart.sh
  361  cp .bash_profile /usr/bin/autostart.sh
  362  cd roxterm/
  363  cd debian/
  364  cat -n install 
  365  pushd
Show the next 9? (Enter/Spc: from newer , b: from older, 0..9 delete by number, else quit) 

If one hit enter, it'll show downwardly continuation of line 366, line 357 - 365    
or if hit b, it'll show history line 1 - 8 and the next b press the continuation of line 9, line 10 - 17   
or if put in 371-359, it will remove these lines
or if put some strings, it'll remove any history line having the string
