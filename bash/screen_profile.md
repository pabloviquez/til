# Screen & Profiles

I love `screen` with a passion, and this is the base profile I use:

```bash

startup_message off

# tab-completion flash in heading bar
vbell off
defscrollback 30000
hardstatus on
startup_message off
caption always "%{= kw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c"
multiuser on

sessionname myProjectName
screen -t "VM1"
stuff "source ~/.bash_profile^M"
stuff "cd ~/projects/xyz^M"
stuff "vagrant up^M"
stuff "vagrant ssh"

screen -t "Code1"
stuff "source ~/.bash_profile^M"
stuff "cd ~/projects/xyz/code_abc^M"
stuff "git pull^M"


```