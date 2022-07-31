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
Next 25? Up/Down: to earlier/later, [-]n[-][n] erase by range, Enter: out. Else: as string to erase 
```
- hit Up key, will show continuation of line 367 downwardly to less line number by 25 lines if it is 1st line, it will wrap around showing the latest line to its next ones
- or Down key, will show next 25 lines, if reaches the latest, it shows beginning of history line again i.e. it will wrap around   
- or Enter then it will go out back to shell prompt   
- put number(s) such as 367, it will remove line 367 or such then followed by number range such as 367 371-373, it will remove lines 367, 371, 372, 373, reverse range boundary such as 375-371 doesn't matter, but note that the **multiple numbers/ranges values must be in ascending order** otherwise it'd delete erronously. If the number(s) range's high limit is the latest one, a dash (-) can be put instead. **371-** it will remove lines 371, 372 ... up to 379   
- put in such --number or --number-number, it will delete the last line(s) relative to the lines currently being shown, for example:   
- put a dash then a number: -5, will remove the 5th line ordered from the latest lines currently being shown   
- put two dash in a row then number: --5, will remove the latest 5 lines to lines currently being shown
- likewise above with addition -number to except the last that number lines, e.g. --5-2 remove the latest 5 lines but the latest 2 lines
- or put others it'll be treated as characters of substring of a command line string as long as having 3 characters or more, any history line having that string will be removed, but if an end is adjacent with space, that end will be treated anchored as the first or last string to search. So surround it with space will turn it to be exact string to match instead of substring
- likewise above but it's only 1 or 2 printable characters, it will be assumed to find that/those exact whole word in a line, but can be made as a substring search too if it's surrounded by space so the opposite of above   
- if input character with `...` (three period in a row) it becomes just a most OS' `\*` wildcard character    
- if input character with `.` (single period) it becomes just a most OS' `\?` wildcard character    
- It can be as the shell prompt (termed as readline) by putting a space first

If one already knew the number or the string, then he can put it directly in shell/terminal prompt such as:   
`$ h 371-375 367`   
`$ cd /home`
Upon exit it will automatically clean up all empty or space only lines   

It'b be also as history alias i.e.

`$ h --help`   
shows history command's helpful reference

`$ h -r`   
append to current history from file ~/.bash_history   

An addition to history option is:   
`$ h -cr`   
reload from file `~/.bash_history`
(clean the current history up and then do as above)   

Except as alias a mere `history` command, type period such as 
`$ h .`   
i.e. simply list them entirely numbered, since `$ h`   
will instead enter the mentioned interactive history tidying   

Do **h -w** to ensure save in ~/.bash_history after tidying up before exit
