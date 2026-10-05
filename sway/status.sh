#!/bin/sh

cleanup() { kill 0; }
trap cleanup EXIT HUP INT TERM

{
    # minute ticker
    while :; do
        echo slow
        sleep $((60 - $(date +%-S)))
    done &

    # volume/sink events
    pactl subscribe 2>/dev/null | grep --line-buffered "on sink"
} | while read -r ev; do
    case $ev in
        slow) battery=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo "N/A") ;;
    esac
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    date_str=$(date +'%a %d %b %H:%M')
    echo "${volume} | BAT: ${battery}% | ${date_str}"
done
