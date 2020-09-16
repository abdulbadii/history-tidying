Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to ~/.bashrc file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by a string segment lying in a history line.   

simply type h then it'll show the latest 17 lines of shell commands e.g:   

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
Show the next 17? (Enter: abort, Up: from end/newer, Down: from begin, [-]n[-][n] erase by number n or range n-n, Others as deletion substring)   

- hit Enter then it will quit back to shell prompt   
- or hit Up key, will show continuation of line 367 upwardly to less number, which is line 358 - 366   
- or hit Down key, it'll show beginning of history line 1 - 13, and next Down is the continuation of line 13: line 14 - 26   
- or put in 371-375, it will remove lines 371, 372, 373, 374, 375. Likewise is for reverse order entry 375-371   
- or could even be put multi numbers in single entry line;   
369 371 377, would clear history number 369, 371, and 377 at once   
- or put other keys it'll be treated as characters of string, more precisely substring of a line, any history line having that string will be removed. If it's only 1 character, that's searched for as a whole word, otherwise if it's more than a character it'll match any line containes string of those characters in any context, but this can be made as whole word search too if it's surrounded by space   

If we're sure we know the number without listing the history, then another way is to put it directly in Bash CLI prompt such as:   
$ h 371-375   

The shorter ways to remove a range of certain number up to the first or last, such as following:   
$ h -375   
$ h 375-   

will result respectively in list number 376 to 379 since all from the first to number 375 get erased and   
list of number 1 up to 374 as the number 375 to the last get cleared   

With exception number: 0,1, and 2, they'll be used to show the last 9, 17, and 34 respectively, so   
$ h 0    
will list the last 9 lines just like   
$ history 9   
will   
  
Upon exit it will automatically clean up all empty or space-only-content lines   

It also serves as history alias, so   

$ h --help   
shows history command's helpful reference

$ h -r   
reload from file ~/.bash_history   
Except it needs to be   
$ h .   
to alias "history" only since   
$ h   
is entering this interactive history tidying   

So don't forget to do
$ h -w

after tidying up and feeling sure it's best improved, so would be saved in ~/.bash_history before exit
