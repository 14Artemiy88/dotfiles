#!/bin/bash

function main2 {
    status=""
    vpn="$(nmcli c show --active | ag vpn | awk -F ' ' '{print $1}')"
    count
    if [[ ${#vpn} -ne 0 ]]; then
        while read -r line; do
            if [[ "$status" = "" ]]; then
                status="#[fg=#ffcccc]🖧  #[fg=#ffcccc]$line #[default] "
            else
                status="$status#[fg=#ffcccc]$line#[default] "
            fi
        done <<< "$vpn"
    fi

    echo "$status"
}

function main {
    vpn=$(nmcli c show --active | ag vpn | awk -F ' ' '{print $1}')
    if [ -n "$vpn" ]; then
        status=$(echo "$vpn" | awk '{printf "#[fg=#ffcccc]%s#[default]  ", $0}' | sed 's/  $//')
        echo "#[fg=#ffcccc]🖧  $status"
    fi
}

main