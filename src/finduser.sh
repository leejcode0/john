#!/bin/bash

# if search comment not provided
if [ $# -eq 0 ]; then
    echo "usage: $(basename "$0") search term..." >&2
    echo "Find every user that has all of the case-insensitive unordered search terms" >&2
    echo "present in his/her account's comment field." >&2
    exit 1
fi

# brings account by passwd getent 
getent passwd | while IFS=: read -r username _ _ _ comment _ _; do
    # pass if there is no comment 
    [ -z "$comment" ] && continue

    # checks for matching comments if no, match = false 
    match=true
    for term in "$@"; do
        if ! echo "$comment" | grep -iq "$term"; then
            match=false
            break
        fi
    done

    # echo if matching 
    if $match; then
        echo "$username,$comment"
    fi
done | {
    # no result = exit 1
    read || exit 1
    # if theres result = echo 
    echo "$REPLY"
    cat
}