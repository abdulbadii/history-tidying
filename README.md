Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to ~/.bashrc file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by string segment lying in a history line.   

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
Show the next 17? (Enter: abort, Up: from newer, Down: from begin, [-]n[-][n] erase by number n (range n-n), Others as deletion substring)   

- hit Enter then it will quit back to shell prompt   
- or hit Up, will show continuation of line 367 downwardly which is line 358 - 366   
- or hit Down, it'll show history line 1 - 13 ie. beginning of command history and next Ctrl-b is the continuation of line 13: line 14 - 26   
- or put in 371-375, it will remove these lines   
- or could even be put multi numbers in single entry line;   
369 371 377, would clear history number 369, 371, and 377 at once   
- or put other keys it'll be treated as characters of string, any history line having that string will be removed   
but if it's only 1 character it'll be searched for as a whole word, otherwise if it's more than a character it'll match any line containes string of those characters in any context, but this can be made as whole word search if we surround it by space   

If we're sure knowing the number(s) then another way is to put it directly in Bash CLI prompt as the following:   
$ h 371-375   

There are some shorter ways to remove a range of certain number up to the first or last, such as following:   

$ h -375   
$ h 375-   

will result respectively in list number 376 to 379 since all from the first to number 375 get erased and   
list of number 1 up to 374 as the number 375 to the last get cleared   

It also serve as history alias, so

$ h --help
shows history helpful reference

$ h -r
reload from file ~/.bash_history

So don't forget do

$ h -w

after tidying it up or feeling sure it's been improved to save it in ~/.bash_history before exit
