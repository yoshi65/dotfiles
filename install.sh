#!/bin/zsh

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    echo "$f"
    if [[ "$f" == ".text" ]]; then
        s=${HOME}"/"${f}
        ln -s $f $s
    fi
done
