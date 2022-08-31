Click, copy "hist.sh" above, then paste, prepend the Bash functions inside to `~/.bashrc` file    

Tidying up Bash commands history by having good control in removing certain line(s) specified by number(s) or range or by a string segment lying in a history line.   

###Requiremnts###   
Bash 5/newer
sed
head
recommended environment variable set: `export HISTCONTROL=erasedups:ignoredups`

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
Up/Down. n[=-n] by line or else string: 
```
- Up key, will show continuation of line 367 to its next 25 lines downwardly, if it is 1st line, it will wrap around showing the latest line to its next 25 ones   
- Down key, as it is at the latest, it will wrap around showing the beginning of history line up to the next 25 lines. It otherwise shows the next 25 lines   
- Enter key will go out back to shell prompt   
- put a number such as 367, it will remove line 367, or `367 371-373` or `367 373-371` to remove lines 367, 371, 372, 373 (reverse range boundary numbers doesn't matter). Note the requirement: A one line **multiple numbers/ranges values must be in ascending order** for any number range format (such above or e.g. `--3` is less than `--7`) otherwise it'd delete erronously. Without a range upper number, it'd default to the last of the currently listed lines i.e. `371-` is to delete lines 371, 372, ...379   
- for the same purpose above can be put as `371=2`. It means 371 and 2 lines succeding it i.e. 371-373 while `371=-3` means 371 and the 3 lines preceding it i.e. 368-371    
- all the above number range can be given out of the currently shown lines as long as max by `9` lines downwardly less than the lowest line or upwardly more than the highest one being shown now. This in order to prevent overlooking   
- put in such `[-]-number[-number]`, it will delete the number ordered from the end (reverse order line number), or if the dash is two, the last number lines, all are relative to lines list being shown then. For example:   
- put a dash and a number e.g. `-5`, will remove the 5th line ordered from the last of lines being shown. A single dash alone `-` is short for `-1` to remove the last line    
- likewise above with appending `=` and a number: `-5=3`, is to remove the 5th line ordered from the last including also the next 3 lines, and `-5=-3` is to remove the 5th line ordered from the last, also the 3 lines preceding it. Omitting the number `-5=` means the number is 1, so equivalent to `-5=1`    
- put two dash in a row then number: `--5`, will remove the last 5 lines relative to the last lines being shown.   
- likewise above with addition -number to except the last that number lines, e.g. `--5-2` remove the last 5 lines but the latest 2 lines, `--5-` will remove the last 5 lines but the last line   
- or put anything else, it'll be treated as the characters of substring of a command line in hisory as long as it has at least 3 printable characters. Any history command line having that string will be searched and printed before being removed. Now if the left/right end is made adjacent with space, that end will be anchored as the first/last string to search, so surrounding it with spaces will turn it to be exact string to match instead of substring   
- likewise above but it has only 1 or 2 printable characters, it will be assumed to find this string as exact, whole line. Alternatively it can be made as a substring search if either one is, or both are, `.`   
- if input character with `.` (single period) it becomes just OS shell `?` wildcard character, while the literal periode is input with `\.`     
- if input character with `...` (three period in a row) it becomes just OS shell `*` wildcard character    
- Do all these easily as it can be as the shell prompt function (well termed as `readline`) by hitting backspace first to get in shell prompt behavour (up/down key to retrieve a command)   

If one already knew the number or the searched string, then just put directly in shell/terminal prompt to delete it such as:   
`$ h 371-373 -1`   

It's also a history alias i.e.   

`$ h --help`   
shows history command's helpful reference

`$ h -r`   
append to current history from file ~/.bash_history   

Addition to history options, there is:   

`$ h -cr`   
reload the history from file `~/.bash_history`
(clean up the current history then do the append previous above)   

Except a mere `h` cannot be as mere `history` command itself to list entire numbered commands, as typing `h` will get into this interactive history tidying so it needs a period following it:    
`$ h .`   

If quit by saving a modified history, it automatically cleans up every empty or space only content line   

Just do **h -w** to ensure it saved in `~/.bash_history` after tidying up before exit the terminal
