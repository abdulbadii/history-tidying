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
- Up key, will show continuation of line 367 downwardly to less line number by 25 lines if it is 1st line, it will wrap around showing the latest line to its next ones
- Down key, will show next 25 lines, if reaches the latest, it shows beginning of history line again i.e. it will wrap around   
- Enter key will go out back to shell prompt   
- put number(s) such as 367, it will remove line 367 or 371-373, it will remove lines 367, 371, 372, 373, reverse range boundary such as 375-371 doesn't matter, or 367 then followed by 375-371 or any number/range else, but note the requirement: one line **multiple numbers/ranges values must be in ascending order** otherwise it'd delete erronously, although the output is always in reverse i.e. descending order. If the range upper end is the last history one, a dash (-) alone will suffice e.g. **371-** it will remove lines 371, 372 ...to 379
- for the same purpose above can be in form 371=2 which means 371 and 2 lines succeding it i.e. 371-373 while 371=-3 means 371 and the 3 lines preceding it i.e. 368-371    
- put in such --number or --number-number, it will delete the last line(s) relative to the lines currently being shown, for example:   
- put a dash then a number: -5, will remove the 5th line ordered from the latest lines being shown now. single dash means -1 which will remove the last line    
- put two dash in a row then number: --5, will remove the last 5 lines relative to lines being shown now   
- likewise above with addition -number to except the last that number lines, e.g. --5-2 remove the last 5 lines but the latest 2 lines, --5- will remove the last 5 lines but the last line   
- or put anything else, it'll be treated as the characters of substring of a command line string as long as it has at least 3 characters. Any history line having that string will be removed, but if the left/right end is made adjacent with space, that end will be anchored as the first/last string to search, so surrounding it with spaces will turn it to be exact string to match instead of substring   
- likewise above but it has only 1 or 2 printable characters, it will be assumed to find the string as exact i.e. whole of the line. Alternatively it can be made as a substring search if it's surrounded by space so the exact opposite of above     
- if input character with `...` (three period in a row) it becomes just OS shell `\*` wildcard character    
- if input character with `.` (single period) it becomes just OS shell `\?` wildcard character while literal periode is input with \\.     
- Do all these finely as it functions as the shell prompt behavior (well termed as readline) by preceding it with space first

If one already knew the number or the searched string, then just put it directly in shell/terminal prompt such as:   
`$ h 371-375 367`   
`$ cd /home`

It'b be also as history alias i.e.

`$ h --help`   
shows history command's helpful reference

`$ h -r`   
append to current history from file ~/.bash_history   

An addition to history options, there is:   

`$ h -cr`   
reload history from file `~/.bash_history`
(clean the current history up and then do as previous above)   

Except the mere `history` command itself to simply list entire numbered command history, as typing h <enter> will get into this interactive history tidying   

So it needs a period such as 
`$ h .`   

Upon exit it will automatically clean up every empty/space content line   

Do **h -w** to ensure save in ~/.bash_history after tidying up before exit
