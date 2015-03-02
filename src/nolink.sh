#!/bin/bash

unlinks=( $(grep -L '\[.*\]\[.*\]' *) )
total_things=$(ls | wc -l)

if [[ -n $1 && $1 == "-l" ]]; then
    echo ${unlinks[@]} | tr ' ' '\n'
else
    echo "${unlinks[$((RANDOM %= $((${#unlinks[@]}))))]}"
    echo "(${#unlinks[@]} of $total_things still to link.)"
fi


#[no link][]
