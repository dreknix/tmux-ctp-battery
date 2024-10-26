#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/scripts/helpers.sh"

primary_ip_interpolations=(
  "\#{battery_icon}"
  "\#{battery_color_bg}"
  "\#{battery_percentage}"
)
primary_ip_commands=(
  "#($CURRENT_DIR/scripts/battery_icon.sh)"
  "#($CURRENT_DIR/scripts/battery_color_bg.sh)"
  "#($CURRENT_DIR/scripts/battery_percentage.sh)"
)

do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#primary_ip_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${primary_ip_interpolations[$i]}/${primary_ip_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main
