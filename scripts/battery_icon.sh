#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${CURRENT_DIR}/helpers.sh"

main() {
  status="$(battery_status)"
  if [ "$status" != "charging" ]; then
    percentage="$(battery_percentage)"

    if [ -n "$percentage" ]; then
      if [ "$percentage" -ge 100 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_full)"
      elif [ "$percentage" -ge 90 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_90)"
      elif [ "$percentage" -ge 80 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_80)"
      elif [ "$percentage" -ge 70 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_70)"
      elif [ "$percentage" -ge 60 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_60)"
      elif [ "$percentage" -ge 50 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_50)"
      elif [ "$percentage" -ge 40 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_40)"
      elif [ "$percentage" -ge 30 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_30)"
      elif [ "$percentage" -ge 20 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_20)"
      elif [ "$percentage" -ge 10 ]; then
        printf "%s" "$(get_tmux_option @battery_charge_icon_10)"
      else
        printf "%s" "$(get_tmux_option @battery_charge_icon_empty)"
      fi
    fi
  else
    percentage="$(battery_percentage)"

    if [ -n "$percentage" ]; then
      if [ "$percentage" -ge 100 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_full)"
      elif [ "$percentage" -ge 90 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_90)"
      elif [ "$percentage" -ge 80 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_80)"
      elif [ "$percentage" -ge 70 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_70)"
      elif [ "$percentage" -ge 60 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_60)"
      elif [ "$percentage" -ge 50 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_50)"
      elif [ "$percentage" -ge 40 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_40)"
      elif [ "$percentage" -ge 30 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_30)"
      elif [ "$percentage" -ge 20 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_20)"
      elif [ "$percentage" -ge 10 ]; then
        printf "%s" "$(get_tmux_option @battery_charging_icon_10)"
      else
        printf "%s" "$(get_tmux_option @battery_charging_icon_empty)"
      fi
    fi
  fi
}

main
