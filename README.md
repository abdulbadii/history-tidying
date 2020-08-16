Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to ~/.bashrc file    

Tidying up Bash commands history by having good control in erasing certain line(s) by specific number(s) / range) or by a string segment in a history line.   

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
Show the next 13? (Enter/Spc: from newer , Ctrl-o: from older, 0..9 delete by number, Others to input string, Escape/Ctrl-c quit)   

If we hit enter, it'll show downwardly continuation of line 366, line 357 - 365    
or if hit control o, it'll show history line 1 - 8 and the next b press the continuation of line 9, line 10 - 17   
or if put in 371-375, it will remove these lines   
or if put some strings, it'll remove any history line having the string   
Escape to quit   

If we're sure know the number(s), another way is to put such directly following it:   
$ h 371-375   

There are some quick way if to remove from a certain number to the first or last, such following respectively:
$ h -375   
$ h 375-   

will result in list of 376 to 379 with the new number 1 to 4, and list of 1 to 374 respectively
