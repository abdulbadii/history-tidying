Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to `~/.bashrc` file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by a string segment lying in a history line.   

simply type `h` then it'll show the latest 25 lines of shell commands e.g:   
```
$ h   
  367  pushd --help   
  368  pushd -n debian/   
  369  pushd  build/   
  370  debuild -i -uc -us -b   
  371  ls debuild*   
  372  ls -hs   
  373  pushd ~   
  374  rm .config/autostart-scripts/autostart.sh   
  375  popd   
  377  cd  
  378  cd debian/   
  379  cat -n install   
Next 25? Up/Down: from last/begin, [-]n[-][n] erase by range, Enter: out. Else: as string to erase 
```
- hit Enter then it will exit back to shell prompt   
- or Up key, will show continuation of line 367 upwardly to less number, which is line 342 - 366   
- or Down key, it'll show beginning of history line 1 - 25, and next Down is the next 25: line 26 - 50   
- put number(s) such as 367, it will remove line 367
- or such that and also number(s) range such as 367 371-373, it will remove lines 367, 371, 372, 373. Likewise is by reverse range order 375-371. 0-99 will remove such the lines    
- the number(s) range if it s high end is the latest command, it can be briefed by a dash(-) e.g. 371-, it will remove lines 371, 372 ... up to 379
- put a dash then a number such as -5, it will remove the 5th line ordered from the latest command history   
- put two dash in a row then number such as --5, it will remove the latest 5 lines of command history   
- or put others it'll be treated as characters of substring of a command line string as long as having 3 characters or more, any history line having that string will be removed, but if an end is adjacent with space, that end will be treated anchored as the first or last string to search. So surround it with space will turn it to be exact string to match instead of substring
- on such above with 1 or 2 printable characters, it will be assumed to find that/those exact whole word in a line, but this can be made as substring search too if it's surrounded by space so the opposite of above   

If we already knew the number without listing the history, then another way is to put it directly in shell/terminal prompt such as:   
$ h 371-375   

Upon exit it will automatically clean up all empty or space only lines   

It'b be also as history alias i.e.

`$ h --help`   
shows history command's helpful reference

`$ h -r`   
append to current history from file ~/.bash_history   

An addition to that:   
`$ h -cr`   
reload from file `~/.bash_history`
(clean the current history up and then do as above)   

Except as alias a mere `history` command, type period such as 
`$ h .`   
i.e. simply list them entirely numbered, since `$ h`   
will instead enter the mentioned interactive history tidying   

Do **h -w** to ensure save in ~/.bash_history after tidying up before exit
