Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to ~/.bashrc file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by string segment lying in a history line.   

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
Show the next 13? (Enter: no/quit, Space: from newer, Ctrl-b: from begin, [-]0..9[-] delete by number/range, Others as a deletion substring)   

hit spacebar, will show continuation of line 367 downwardly which is line 358 - 366   
or hit Ctrl-b, it'll show history line 1 - 13 ie. beginning of command history and next Ctrl-b is the continuation of line 13: line 14 - 26   
or put in 371-375, it will remove these lines   
or put other keys it'll be treated as characters string, it'll remove any history line having that string   
or hit Enter then it will quit   
or could even be put multi numbers in single entry line;   
369 371 377, would clear history number 369, 371, and 377 once

If we're sure knowing the number(s) then another way is to put it directly in Bash CLI prompt as the following:   
$ h 371-375   

There are some shoter way to remove from a certain number to the first or last, such as following:   

$ h -375   
$ h 375-   

will result respectively in list number 376 to 379 as all from  the first to number 375 get erased and   
list of number 1 up to 374 as the number 375 to the last get cleared   
