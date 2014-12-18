#!/bin/bash

#This file forces a custom theme for GTK+ applications
# in this case I prefer most of the time a light theme for apps (firefox)
# but for control programs/tools (eg my custom YADWIN) I prefer darker themes

GTK2_RC_FILES=/home/admalledd/.i3/gtk2_darktheme_override.gtkrc-2.0 GTK_THEME=Darklooks $*