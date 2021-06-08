################################################################################
#    _       ______  ____  __ __    __  ______   ________  _______   ________
#   | |     / / __ \/ __ \/ //_/   /  |/  /   | / ____/ / / /  _/ | / / ____/
#   | | /| / / / / / /_/ / ,<     / /|_/ / /| |/ /   / /_/ // //  |/ / __/
#   | |/ |/ / /_/ / _, _/ /| |   / /  / / ___ / /___/ __  // // /|  / /___
#   |__/|__/\____/_/ |_/_/ |_|  /_/  /_/_/  |_\____/_/ /_/___/_/ |_/_____/
#
################################################################################
# Machine specific i3 configurations like workspace names, rig specific
# shortcuts and other things.
################################################################################

set $BAR_SIZE 14

# Get all screens
; export SC1=$(xrandr | grep " connected" | sed -n '1 p' | awk '{print $1;}')
; export SC2=$(xrandr | grep " connected" | sed -n '2 p' | awk '{print $1;}')
; export SC3=$(xrandr | grep " connected" | sed -n '3 p' | awk '{print $1;}')
set $SC1 {{$SC1}}
set $SC2 {{$SC2}}
set $SC3 {{$SC3}}

# Browser
set $WS1 "1:    "
# Terminal
set $WS2 "2:    "
# Free
set $WS3 "3:  3  "
set $WS4 "4:  4  "
set $WS5 "5:  5  "
set $WS6 "6:  6  "
set $WS7 "7:  7  "
set $WS8 "8:  8  "
set $WS9 "9:  9  "
# Music
set $WS10 "10:    "
# Settings
set $WS11 "11:    "

# Right screen
; if [ ! -z "$SC3" ]; then # if at least 3 screens
set $WS101 "101:    "
bindsym $mod+equal workspace $WS101
bindsym $mod+Shift+plus move container to workspace $WS101
;fi

# Left screen
; if [ ! -z "$SC2" ]; then # if at least 2 screens
set $WS14 "201:    "
bindsym $mod+grave workspace $WS14
bindsym $mod+Shift+grave move container to workspace $WS14
;fi
set $WS15 "202:    "
set $WS16 "203:    "

# switch to workspace
bindsym $mod+1 workspace $WS1
bindsym $mod+2 workspace $WS2
bindsym $mod+3 workspace $WS3
bindsym $mod+4 workspace $WS4
bindsym $mod+5 workspace $WS5
bindsym $mod+6 workspace $WS6
bindsym $mod+7 workspace $WS7
bindsym $mod+8 workspace $WS8
bindsym $mod+9 workspace $WS9
bindsym $mod+0 workspace $WS10
bindsym $mod+minus workspace $WS11
bindsym $mod+q workspace $WS15

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $WS1
bindsym $mod+Shift+2 move container to workspace $WS2
bindsym $mod+Shift+3 move container to workspace $WS3
bindsym $mod+Shift+4 move container to workspace $WS4
bindsym $mod+Shift+5 move container to workspace $WS5
bindsym $mod+Shift+6 move container to workspace $WS6
bindsym $mod+Shift+7 move container to workspace $WS7
bindsym $mod+Shift+8 move container to workspace $WS8
bindsym $mod+Shift+9 move container to workspace $WS9
bindsym $mod+Shift+0 move container to workspace $WS10
bindsym $mod+Shift+underscore move container to workspace $WS11

# Assign workspaces to Monitors
workspace $WS1 output $SC2
workspace $WS2 output $SC2
workspace $WS3 output $SC2
workspace $WS4 output $SC2
workspace $WS5 output $SC2
workspace $WS6 output $SC2
workspace $WS7 output $SC2
workspace $WS8 output $SC2
workspace $WS9 output $SC2
workspace $WS10 output $SC2
workspace $WS11 output $SC2

workspace $WS14 output $SC1
workspace $WS15 output $SC1
workspace $WS16 output $SC1

# Pulse Audio controls
bindsym XF86AudioRaiseVolume exec --no-startup-id "sound up"
bindsym XF86AudioLowerVolume exec --no-startup-id "sound down"
bindsym XF86AudioMute        exec --no-startup-id "sound mute"

#swap caps and escape for better VIMing and swap alt and winkey for better i3ing
exec_always --no-startup-id /usr/bin/setxkbmap -option "caps:swapescape" -option "altwin:swap_lalt_lwin"

#configure monitors
; if [ -z "$SC2" ]; then
exec_always --no-startup-id "xrandr --output {{$SC1}} --auto --primary"
; elif [ -z "$SC3" ]; then
# exec_always --no-startup-id "xrandr --output {{$SC1}} --auto --output {{$SC2}} --off"
exec_always --no-startup-id "xrandr --output {{$SC1}} --auto --output {{$SC2}} --auto --right-of {{$SC1}} --primary "
; else
# exec_always --no-startup-id "xrandr --output {{$SC1}} --auto --output {{$SC2}} --off --output {{$SC3}} --off"
exec_always --no-startup-id "xrandr --output {{$SC1}} --auto --output {{$SC2}} --auto --right-of {{$SC1}} --primary --output {{$SC3}} --auto --right-of {{$SC2}}"
; fi

#configure touchscreen
; export TOUCHSCREEN=$(xinput --list | grep "pointer" | grep "Wacom" | sed 's/.*\(Wacom.*\w\)\s*id.*/'\''\1'\''/')
exec_always --no-startup-id "xinput --map-to-output {{$TOUCHSCREEN}} $SC1"

# Start programs and assign to workspaces

# Set layouts for monitors to assign programs to specific positions
# exec --no-startup-id i3-msg 'workspace $WS1; append_layout $LAYOUTS/chromium.json'
exec --no-startup-id i3-msg 'workspace $WS1; append_layout $LAYOUTS/brave.json'
#exec --no-startup-id i3-msg 'workspace $WS2; append_layout $LAYOUTS/gnome-terminal.json'
exec --no-startup-id i3-msg 'workspace $WS11; append_layout $LAYOUTS/pavucontrol.json'
#exec --no-startup-id i3-msg 'workspace $WS14; append_layout $LAYOUTS/firefox.json'

# Set standard workspaces for programs
# small screen
for_window [class="^Rambox$"]               move to workspace $WS15
for_window [class="^discord$"]              move to workspace $WS15

for_window [class="^Microsoft\ Teams.*$"]   move to workspace $WS15
for_window [class="^KeePassXC$"]            move to workspace $WS16

# main screen
for_window [class="^jetbrains-studio$"]     move to workspace $WS3
# for_window [class="^Thunar$"]               move to workspace $WS9
for_window [class="Spotify"]                move to workspace $WS10

hide_edge_borders horizontal

# Set the window borders to indicate the current focused window
# default_border pixel 2
for_window [class="^.*"] border pixel 5
# for_window [class="^Google-chrome$"] border pixel 0
# for_window [class="^Brave-browser$"] border pixel 0
# for_window [class="^Chromium$"] border pixel 0
# for_window [class="^Firefox$"] border pixel 0
no_focus [window_role="pop-up"]
for_window [title="^https://hangouts.google.com - Google Hangouts - Mozilla Firefox$"] floating disable

bindsym $mod+x exec brave --profile-directory="Profile 1"
bindsym $mod+Shift+x exec brave --incognito --profile-directory="Profile 1"

# Start programs
exec --no-startup-id "brave"
exec --no-startup-id "spotify"
exec --no-startup-id "pavucontrol"
exec --no-startup-id "teams"
exec --no-startup-id "rambox"
exec --no-startup-id "keepassxc"

exec --no-startup-id "insync start"
exec --no-startup-id "blueman-applet"

# Finally focus workspace 1
exec --no-startup-id i3-msg 'workspace $WS1'

# ### Hacky scripts to run ### #
# mouse sensitivity
# mouse_warping none
exec --no-startup-id "set_sensitivity.sh"
# chrome textdrag
exec --no-startup-id "chrome_text_drag.py"

# start a terminal
bindsym $mod+Return exec urxvt

exec_always --no-startup-id feh --bg-scale --no-xinerama --randomize $WALLPAPERS/5760/nature/*

exec_always --no-startup-id "picom --config $CONFIG/compton.conf"

#Automatic back-and-forth when switching to the current workspace
# https://i3wm.org/docs/userguide.html#workspace_auto_back_and_forth
# workspace_auto_back_and_forth yes

bindsym $mod+n exec $SCRIPTS/wifi.sh

