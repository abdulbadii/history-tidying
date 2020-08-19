Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to ~/.bashrc file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by a substring segment in a history line.   

simply type h then it'll show first 13 lines of last shell commands e.g:   

$ h   
  367  pushd --help   
  368  pushd -n debian/   
  369  pushd  build/   
  370  debuild -i -uc -us -b   
  371  ls debuild*   
  372  ls -hs   
  373  cd ../debian/   
  374  rm .config/autostart-scripts/autostart.sh   
  375  pushd   
  376  cp .bash_profile /usr/bin/autostart.sh   
  377  cd roxterm/   
  378  cd debian/   
  379  cat -n install   
Show the next 13? (Enter/Spc: from newer , Ctrl-o: from older, Escape/Ctrl-C quit, 0..9 delete by number, Others is as a deletion substring)   

If we hit enter, it'll show downwardly continuation of line 367 which is line 358 - 366   
or if hit Ctrl-O, it'll show history line 1 - 13 and next Ctrl-O is the continuation of line 13: line 14 - 26   
or if put in 371-375, it will remove these lines   
or if put other keys it'll be treated as a sub string, it'll remove any history line having that string   
or Ctrl-c or Escape to quit   

If we're sure knowing the number(s) then another way is to put it directly in CLI way as thefollowing:   
$ h 371-375   

There are some shoter way to remove from a certain number to the first or last, such as following:
$ h -375   
$ h 375-   

will result respectively in list of 376 to 379 with the first up to number 375 is erased, and list 1 up to 374 as number 375 to the last is gone   
