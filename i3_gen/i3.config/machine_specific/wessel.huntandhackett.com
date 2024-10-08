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
exec_always --no-startup-id "{{$($HOME/.config/i3/scripts/monitors.sh)}}"
; export SC1=$(cat /tmp/monitors/SC1)
; export SC2=$(cat /tmp/monitors/SC2)
; export SC3=$(cat /tmp/monitors/SC3)
; export WALLPAPER_SIZE=$(cat /tmp/monitors/wallpapers_size)

exec_always --no-startup-id feh --bg-scale --no-xinerama --randomize $WALLPAPERS/{{$WALLPAPER_SIZE}}/nature/*

set $SC1 {{$SC1}}
set $SC2 {{$SC2}}
set $SC3 {{$SC3}}

# Browser
set $WS001 "1:    "
# Terminal
set $WS002 "2:    "
# Free
set $WS003 "3:  3  "
set $WS004 "4:  4  "
set $WS005 "5:  5  "
set $WS006 "6:  6  "
set $WS007 "7:  7  "
set $WS008 "8:  8  "
set $WS009 "9:  9  "
# Music
set $WS010 "10:    "
# Settings
set $WS011 "11:    "

# Right screen
; if [ ! -z "$SC3" ]; then # if 3 screens
set $WS101 "101:    "
bindsym $mod+minus workspace $WS101
bindsym $mod+Shift+underscore move container to workspace $WS101
;fi

# Left screen
; if [ ! -z "$SC2" ]; then # if at least 2 screens
set $WS014 "201:    "
bindsym $mod+grave workspace $WS014
bindsym $mod+Shift+grave move container to workspace $WS014
bindsym $mod+equal workspace $WS014
bindsym $mod+Shift+plus move container to workspace $WS014
;fi
set $WS015 "202:    "
set $WS016 "203:    "

# switch to workspace
bindsym $mod+1 workspace $WS001
bindsym $mod+2 workspace $WS002
bindsym $mod+3 workspace $WS003
bindsym $mod+4 workspace $WS004
bindsym $mod+5 workspace $WS005
bindsym $mod+6 workspace $WS006
bindsym $mod+7 workspace $WS007
bindsym $mod+8 workspace $WS008
bindsym $mod+9 workspace $WS009
bindsym $mod+0 workspace $WS010
bindsym $mod+q workspace $WS015

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $WS001
bindsym $mod+Shift+2 move container to workspace $WS002
bindsym $mod+Shift+3 move container to workspace $WS003
bindsym $mod+Shift+4 move container to workspace $WS004
bindsym $mod+Shift+5 move container to workspace $WS005
bindsym $mod+Shift+6 move container to workspace $WS006
bindsym $mod+Shift+7 move container to workspace $WS007
bindsym $mod+Shift+8 move container to workspace $WS008
bindsym $mod+Shift+9 move container to workspace $WS009
bindsym $mod+Shift+0 move container to workspace $WS010

# Assign workspaces to Monitors
workspace $WS101 output $SC3

workspace $WS001 output $SC2
workspace $WS002 output $SC2
workspace $WS003 output $SC2
workspace $WS004 output $SC2
workspace $WS005 output $SC2
workspace $WS006 output $SC2
workspace $WS007 output $SC2
workspace $WS008 output $SC2
workspace $WS009 output $SC2
workspace $WS010 output $SC2
workspace $WS011 output $SC2

workspace $WS014 output $SC1
workspace $WS015 output $SC1
workspace $WS016 output $SC1

bindsym $mod+F1 exec screen toggle
bindsym $mod+F2 exec bash -c '[ $(lsmod | grep ^uvcvideo | tr -s " " | cut -d " " -f3) -ne 0 ] && home webcam || home nowebcam'
bindsym $mod+F3 exec home desk
bindsym $mod+F4 exec home deskfan
bindsym $mod+F5 exec home windowfan

# Pulse Audio controls
bindsym XF86AudioRaiseVolume exec --no-startup-id "sound up"
bindsym XF86AudioLowerVolume exec --no-startup-id "sound down"
bindsym XF86AudioMute        exec --no-startup-id "sound mute"

#swap caps and escape for better VIMing and swap alt and winkey for better i3ing
exec_always --no-startup-id /usr/bin/setxkbmap -option "caps:swapescape" -option "altwin:swap_lalt_lwin"

#configure touchscreen
#; export TOUCHSCREEN=$(xinput --list | grep "pointer" | grep "Wacom" | sed 's/.*\(Wacom.*\w\)\s*id.*/'\''\1'\''/')
#exec_always --no-startup-id "xinput --map-to-output {{$TOUCHSCREEN}} $SC1"

# lock screen automatically after 1 minute
exec_always --no-startup-id xset s noblank
exec_always --no-startup-id xset dpms 0 0 60
exec_always --no-startup-id xss-lock -- lock


# Start programs and assign to workspaces

# Set layouts for monitors to assign programs to specific positions
# exec --no-startup-id i3-msg 'workspace $WS001; append_layout $LAYOUTS/chromium.json'
# exec --no-startup-id i3-msg 'workspace $WS001; append_layout $LAYOUTS/brave.json'
exec --no-startup-id i3-msg 'workspace $WS001; append_layout $LAYOUTS/edge.json'
#exec --no-startup-id i3-msg 'workspace $WS002; append_layout $LAYOUTS/gnome-terminal.json'
exec --no-startup-id i3-msg 'workspace $WS011; append_layout $LAYOUTS/pavucontrol.json'
#exec --no-startup-id i3-msg 'workspace $WS014; append_layout $LAYOUTS/firefox.json'
exec --no-startup-id i3-msg 'workspace $WS016; append_layout $LAYOUTS/1pass.json'

# Set standard workspaces for programs
# small screen
for_window [class="^Rambox$"]               move to workspace $WS015
for_window [class="^Signal$"]               move to workspace $WS015
for_window [class="^discord$"]              move to workspace $WS015

for_window [title="^Microsoft\\ Teams.*$"]               move to workspace $WS015
for_window [instance="^crx_cifhbcnohmdccbgoicgdjpfamggdegmo$"]               move to workspace $WS015

for_window [class="^Microsoft\ Teams.*$"]   move to workspace $WS015
#for_window [class="^KeePassXC$"]            move to workspace $WS016
#for_window [class="^1Password$" floating]   move to workspace $WS016



# main screen
for_window [class="^jetbrains-studio$"]     move to workspace $WS003
# for_window [class="^Thunar$"]               move to workspace $WS009
for_window [class="Spotify"]                move to workspace $WS010

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

# bindsym $mod+c exec brave-browser --profile-directory=Default
# bindsym $mod+Shift+c exec brave-browser --incognito --profile-directory=Default
# bindsym $mod+x exec brave-browser --profile-directory="Profile 1"
# bindsym $mod+Shift+x exec brave-browser --incognito --profile-directory="Profile 1"

bindsym $mod+c exec microsoft-edge
bindsym $mod+Shift+c exec microsoft-edge --incognito
bindsym $mod+x exec brave-browser --profile-directory="Profile 1"
bindsym $mod+Shift+x exec brave-browser --incognito --profile-directory="Profile 1"

# Start programs
# exec --no-startup-id "brave-browser --profile-directory=Default"
exec --no-startup-id "microsoft-edge"
exec --no-startup-id "spotify"
exec --no-startup-id "pavucontrol"
# exec --no-startup-id "teams"
exec --no-startup-id "rambox"
exec --no-startup-id "cat $(grep -lwr 'Microsoft Teams' ~/Desktop) | grep '^Exec' | sed 's/^Exec=//' | bash"

exec --no-startup-id "signal-desktop"
exec --no-startup-id "keepassxc"

exec --no-startup-id "insync start"
exec --no-startup-id "1password"
exec --no-startup-id "blueman-applet"

# Finally focus workspace 1
exec --no-startup-id i3-msg 'workspace $WS001'

# ### Hacky scripts to run ### #
# mouse sensitivity
# mouse_warping none
exec --no-startup-id "set_sensitivity.sh"
# chrome textdrag
exec --no-startup-id "chrome_text_drag.py"

# exec_always --no-startup-id "picom --config $CONFIG/compton.conf -b"
exec --no-startup-id "python3 ~/bin/defender-alert.py"

exec_always --no-startup-id "xset mouse 2 0"
exec_always --no-startup-id "xset r rate 280 40"

exec --no-startup-id "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"

#Automatic back-and-forth when switching to the current workspace
# https://i3wm.org/docs/userguide.html#workspace_auto_back_and_forth
# workspace_auto_back_and_forth yes

bindsym $mod+n exec $SCRIPTS/wifi.sh

# Open todo.md
bindsym $mod+o exec --no-startup-id "alacritty -e bash -c 'source ~/.profile && i3 floating toggle && nvim ~/todo.yaml'"

bindsym $mod+p exec --no-startup-id "flameshot gui"

