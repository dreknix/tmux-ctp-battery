#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/helpers.sh"

main() {
  percentage="$(battery_percentage)"

  if [ -n "$percentage" ]; then
    if [ "$percentage" -ge 70 ]; then
      printf "%s" "$(get_tmux_option @battery_high_bg_color)"
    elif [ "$percentage" -ge 30 ]; then
      printf "%s" "$(get_tmux_option @battery_medium_bg_color)"
    else
      printf "%s" "$(get_tmux_option @battery_low_bg_color)"
    fi
  fi
}

main
