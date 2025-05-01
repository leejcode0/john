#!/bin/bash

# brings all processes UID and CPU 
ps -eo uid,time --no-headers | while read -r uid time; do
    # changes CPU time to unit second
    IFS=: read -r hours minutes seconds <<< "$time"
    total_seconds=$((hours * 3600 + minutes * 60 + seconds))

    # binds UID and times 
    if [ -n "${cpu_time[$uid]}" ]; then
        cpu_time[$uid]=$((cpu_time[$uid] + total_seconds))
    else
        cpu_time[$uid]=$total_seconds
    fi
done

# change UID to full name and echo results
for uid in "${!cpu_time[@]}"; do
    # brings full name of UID by using getent
    user_info=$(getent passwd "$uid")
    if [ -n "$user_info" ]; then
        IFS=: read -r _ _ _ _ comment _ <<< "$user_info"
        # changes CPU time to hours, min, seconds
        total_seconds=${cpu_time[$uid]}
        hours=$((total_seconds / 3600))
        minutes=$(( (total_seconds % 3600) / 60 ))
        seconds=$((total_seconds % 60))
        time_str=$(printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds")

        # echo results
        echo -e "$uid\t$time_str\t$comment"
    fi
done | sort -k2,2hr  # decending order by CPU time