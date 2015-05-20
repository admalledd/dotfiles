

My i3+i3Blocks config

Based on Linux Mint 17 "Qiana" XFCE4 (which itself is based on Ubuntu 14.04 "Trusty")


#Directories

* i3blocks: scripts to help control/populate i3blocks with handy stuff. Also helps with click event things.
* i3bin: scripts that I symlink to `$HOME/bin/` such that I can use them from my command line as well as call them for i3 stuff


Some of my scripts are from other sources (but almost always modified for my own system) I try my best to comment in the file itself where I got them from. If I missed a source please let me know! Sometimes I find a file/script and loose where it came from and almost always there are more interesting scripts that I wanted to check out as well.

I also forget exactly what packages I added beyond the base install to get this all working (ofc including installing i3wm, i3blocks..)


#Packages

Format is that the link text is the path to the executable, and the link is the source/docs on how to use/install

* [$HOME/dev/lighthouse/lighthouse](https://github.com/emgram769/lighthouse)
* [$HOME/dev/i3blocks/i3blocks](https://github.com/vivien/i3blocks)

#Helper files

* `mklinks.sh`: should make all those pesky symlinks all around for ya. although you will probably still want to `grep` around for my user name and replace those. Too many of these programs/tools don't allow environ vars (eg ${HOME}) such that I could make it simpler...
* `gtk_darktheme_runme.sh`: for just when I want to override the default GTK theme (gtk2 in particular, but could allow GTK3 and such)