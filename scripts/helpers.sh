#!/usr/bin/env bash

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

battery_status_acpi() {
  acpi -b | awk '{gsub(/,/, ""); print tolower($3); exit}'
}

battery_percentage_acpi() {
  acpi -b | grep -m 1 -Eo "[0-9]+%"
}

battery_status_apm() {
  local battery
  battery=$(apm -a)
  if [ "$battery" -eq 0 ]; then
    printf "discharging"
  elif [ "$battery" -eq 1 ]; then
    printf "charging"
  fi
}

battery_percentage_apm() {
  apm -l
}

battery_status_pmset() {
  pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
}

battery_percentage_pmset() {
  pmset -g batt | grep -o "[0-9]\{1,3\}"
}

battery_status_termux() {
  termux-battery-status | jq -r '.status' | awk '{printf("%s", tolower($1))}'
}

battery_percentage_termux() {
  termux-battery-status | jq -r '.percentage' | awk '{printf("%d", $1)}'
}

battery_status_upower() {
  local battery
  battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
  upower -i "$battery" | awk '/state/ {print $2}'
}

battery_percentage_upower() {
  # use DisplayDevice if available otherwise battery
  local battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
  if [ -z "$battery" ]; then
    return
  fi
  local percentage=$(upower -i "$battery" | awk '/percentage:/ {printf "%s",$2}')
  if [ "$percentage" ]; then
    shopt -s extglob
    echo "${percentage%%?(.*)?(%)}"
    return
  fi
  local energy
  local energy_full
  energy=$(upower -i "$battery" | awk -v nrg="$energy" '/energy:/ {print nrg+$2}')
  energy_full=$(upower -i "$battery" | awk -v nrgfull="$energy_full" '/energy-full:/ {print nrgfull+$2}')
  if [ -n "$energy" ] && [ -n "$energy_full" ]; then
    echo "$energy" "$energy_full" | awk '{printf("%d", ($1/$2)*100)}'
  fi
}

battery_status_sysfs() {
  local battery
  battery=$(find /sys/class/power_supply/BAT*/status | tail -n1)
  awk '{print tolower($0);}' "$battery"
}

battery_percentage_sysfs() {
  local battery
  battery=$(find /sys/class/power_supply/BAT*/capacity | tail -n1)
  cat "$battery"
}

battery_status() {
  backend="$(get_tmux_option '@battery_backend' 'auto')"
  case "$backend" in
    acpi)
      battery_status_acpi
      ;;
    apm)
      battery_status_apm
      ;;
    pmset)
      battery_status_pmset
      ;;
    sysfs)
      battery_status_sysfs
      ;;
    termux)
      battery_status_termux
      ;;
    upower)
      battery_status_upower
      ;;
    auto)
      if command_exists "pmset"; then
        battery_status_pmset
      elif command_exists "acpi"; then
        battery_status_acpi
      elif command_exists "upower"; then
        battery_status_upower
      elif command_exists "termux-battery-status"; then
        battery_status_termux
      elif command_exists "apm"; then
        battery_status_apm
      else
        battery_status_sysfs
      fi
      ;;
    *)
      battery_status_sysfs
      ;;
  esac
}

battery_percentage() {
  backend="$(get_tmux_option '@battery_backend' 'auto')"
  case "$backend" in
    acpi)
      battery_percentage_acpi
      ;;
    apm)
      battery_percentage_apm
      ;;
    pmset)
      battery_percentage_pmset
      ;;
    sysfs)
      battery_percentage_sysfs
      ;;
    termux)
      battery_percentage_termux
      ;;
    upower)
      battery_percentage_upower
      ;;
    auto)
      if command_exists "pmset"; then
        battery_percentage_pmset
      elif command_exists "acpi"; then
        battery_percentage_acpi
      elif command_exists "upower"; then
        battery_percentage_upower
      elif command_exists "termux-battery-status"; then
        battery_percentage_termux
      elif command_exists "apm"; then
        battery_percentage_apm
      else
        battery_percentage_sysfs
      fi
      ;;
    *)
      battery_percentage_sysfs
      ;;
  esac
}
