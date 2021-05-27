#!/bin/sh
bat_state=$(upower -i $(upower -e | grep BAT) | grep state |awk '{print $2}' | tr -d '\n')
bat_percentage=$(upower -i $(upower -e | grep BAT) | grep percentage |awk '{print $2}' | tr -d '\n')
printf $bat_state" "$bat_percentage
