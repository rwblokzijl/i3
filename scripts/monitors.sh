set -eo pipefail

get_current_monitor_edids() {
  SED_REMOVE_DISCONNECTED='s/\r[0-9a-zA-Z-]* disconnected[^\r]*\(\r\t[^\r]*\)*//g'
  SED_FILTER_EDIDS='s/\(\r[0-9a-zA-Z-]*\) connected[^\r]*\r\tEDID: \(\(\r\t\t[0-9a-f]*\)*\)\(\r\s[^\r]*\)*/\1,\2/g'
  SED_REMOVE_HEADER_LINE='s/^Screen[^\r]*\r//;s/\r\t\t//g'
  xrandr --prop | \
    tr '\n' '\r' | \
    sed "$SED_REMOVE_DISCONNECTED;$SED_FILTER_EDIDS;$SED_REMOVE_HEADER_LINE" | \
    tr '\r' '\n' | \
    jq -nRc '[inputs]|map(split(","))|map({(.[1]):.[0]})|add'
}

get_config() {
  cat ~/.config/i3/monitors.yaml | yq -o json
}

filter_satisfied_configs() {
  # Gets the configs where all monitors are connected
    jq --argjson CURRENT_MONITOR_EDIDS "${1}" \
    '.setups|map(select([.monitors[]]|inside($CURRENT_MONITOR_EDIDS|keys)))|sort_by(.monitors|length)|reverse'
}

filter_exact_matching_config() {
    jq -e --argjson CURRENT_MONITOR_EDIDS "${1}" \
    '.setups|map(select(([.monitors[]]|sort)==($CURRENT_MONITOR_EDIDS|keys|sort)))'
}

filter_best_config() {
  CONFIG=$(cat)
  echo $CONFIG | filter_exact_matching_config "$1" | jq -e '.!=[]' > /dev/null && echo $CONFIG | filter_exact_matching_config "$1" | jq '.[0]' && return
  echo $CONFIG | filter_satisfied_configs "$1" | jq -e '.!=[]' > /dev/null && echo $CONFIG | filter_satisfied_configs "$1" | jq '.[0]' && return
  false
}

compute_monitor_edid_ordered() {
  jq '.monitors|to_entries|sort_by(.key)|map(.value)'
}

compute_primary_monitor_edid() {
  CONFIG=$(cat)
  MONITOR_PRIMARY=$(echo $CONFIG | jq '.primary')
  echo $CONFIG | jq --arg MONITOR_PRIMARY "$MONITOR_PRIMARY" '.monitors[$MONITOR_PRIMARY]'
}

compute_monitor_names_from_edids() {
  jq -r --argjson CURRENT_MONITOR_EDIDS "${1}" \
    'map($CURRENT_MONITOR_EDIDS[.])[]'
}

get_screen_config() {
  CURRENT_MONITOR_EDIDS=$(get_current_monitor_edids)
  BEST_CONFIG=$(get_config | filter_best_config "${CURRENT_MONITOR_EDIDS}")
  MONITORS_ORDERED=$(echo $BEST_CONFIG | compute_monitor_edid_ordered | compute_monitor_names_from_edids "$CURRENT_MONITOR_EDIDS")
  MONITOR_PRIMARY=$(echo $BEST_CONFIG | compute_primary_monitor_edid | jq '[.]' | compute_monitor_names_from_edids "$CURRENT_MONITOR_EDIDS")
  PREVIOUS="NONE"
  XRANDR="xrandr"
  ALL_MONITORS=$(echo $CURRENT_MONITOR_EDIDS | jq -r '.[]')
  UNUSED_MONITORS=$(echo $ALL_MONITORS $MONITORS_ORDERED | tr ' ' '\n' | sort | uniq -u)
  COUNT=1
  echo 3
  rm -rf /tmp/monitors
  mkdir -p /tmp/monitors
  for MONITOR in $MONITORS_ORDERED
  do

    XRANDR+=" --output $MONITOR --auto"
    POS=$(echo $BEST_CONFIG | jq -r --arg COUNT $(($COUNT-1)) '.pos[$COUNT]//empty')
    if [[ ! -z "$POS" ]];then
        XRANDR+=" --pos $POS"
    else
      if [[ "$PREVIOUS" != "NONE" ]];then
        XRANDR+=" --right-of $PREVIOUS"
      fi
    fi

    MODE=$(echo $BEST_CONFIG | jq -r --arg COUNT $(($COUNT-1)) '.mode[$COUNT]//empty')
    if [[ ! -z "$MODE" ]];then
        XRANDR+=" --mode $MODE"
    fi

    if [[ "$MONITOR" == "$MONITOR_PRIMARY" ]];then
      XRANDR+=" --primary"
    fi

    ROTATE=$(echo $BEST_CONFIG | jq -r --arg COUNT $(($COUNT-1)) '.rotate[$COUNT]//empty')
    if [[ ! -z "$ROTATE" ]];then
      XRANDR+=" --rotate $ROTATE"
    fi

    PREVIOUS=$MONITOR
    echo $MONITOR > /tmp/monitors/SC${COUNT}
    COUNT=$(($COUNT+1))
  done
  echo "$BEST_CONFIG" | jq -r '.wallpapers_size' > /tmp/monitors/wallpapers_size
  for MONITOR in $UNUSED_MONITORS
  do
    XRANDR+=" --output $MONITOR --off"
  done
  >&2 echo $MONITORS_ORDERED
  echo $XRANDR
  $XRANDR
}

get_screen_config
