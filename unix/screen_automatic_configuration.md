# Screen & Automatic Configuration

Screen is awesome, close your terminal go home, comeback and you have everything right there.

```bash
screen
```

Out of the box is weird but you can configure it so loads everything just like you want automatically:

## Screen Config

Save the following file in your home with the name .screenrc_xyz

```bash
startup_message off

# tab-completion flash in heading bar
vbell off
defscrollback 30000
hardstatus on
startup_message off
caption always "%{= kw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c"
multiuser on

sessionname myxyz
screen -t "Screen1 - Code"
stuff "source ~/.bash_profile^M"
stuff "cd ~/projects/xyz^M"
stuff "git pull^M"

screen -t "Screen2 - MySQL"
stuff "source ~/.bash_profile^M"
stuff "cd ~/projects/xyz^M"
stuff "mysql -uroot -p^M"

```

Now start the session as follow:

```bash
screen -c ~/.screenrc_xyz
```

Automatically will create a new screen called "myxyz" with 2 screens on it.

If you're lazy and dont want to kill screen by screen, kill it as follow:

### How many Screen sessions do I have running?

```bash
> screen -ls

There are screens on:
    15967.myxyz (Multi, detached)
1 Socket in /var/folders/cv/p402vycd0b3g5hy2mk66p1b5lfrh0b/T/.screen.
```

### How to attach or return to a previous screen session?
Using screen list from previous step.
```bash
> screen -r -d 15967.myxyz
```


### Quit / Kill one screen session

```bash

> screen -S myxyz -X quit

```