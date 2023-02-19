#!/bin/bash

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue

    echo "$f"
    s=${HOME}"/"${f}
    f=`pwd`"/"${f}
    ln -s $f $s
done
