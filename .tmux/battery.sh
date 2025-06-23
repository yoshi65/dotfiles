#!/bin/zsh
#
# FileName: 	battery
# CreatedDate:  2019-04-11 16:13:01 +0900
# LastModified: 2019-04-15 11:11:00 +0900
#

if battery_info=$(/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $3 " " $4 }' | sed -e "s/;//g;s/%//"); then
    # check charging
    charging=""
    if [[ ! $battery_info =~ "discharging" ]]; then
        charging=" "
    fi
    # check battery quantity
    battery_quantity=$(echo $battery_info | awk '{print $1}')
    if (( $battery_quantity < 61 )); then
        battery="#[bg=yellow,fg=black] $charging$battery_quantity% #[default]"
    elif (( $battery_quantity < 21 )); then
        battery="#[bg=red,fg=white] $charging$battery_quantity% #[default]"
    else
        battery="#[bg=cyan,fg=black] $charging$battery_quantity% #[default]"
    fi

    echo $battery
fi
