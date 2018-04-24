#!/bin/zsh

# variable
name_list=(`ls -a`)
name_list=(${name_list[3,-1]}) # ., .. remove
dtxt="diff.txt"

# exec sync
for name in ${name_list}
do
    #isFile
    if [[ -f ${name} && `echo ${name} | grep -c "^\."` != 0 ]]; then
        echo ${name}
        current=`echo "./${name}"`
        dot=`echo "${HOME}/${name}"`
        diff -u ${current} ${dot} > ${dtxt}
        if [ ! -s ./${dtxt} ]; then
          echo -e "\033[0;32mno diff\033[0;39m"
        else
          echo -e "\033[0;31mdiff\033[0;39m"
          patch -u ${current} < ${dtxt}
        fi
    # isDirectory
    elif [[ -d ${name} && `echo ${name} | grep -c "^\.git$"` == 0 ]]; then
        # file_list=(`ls -a ${name}`)
        # file_list=(${file_list[3,-1]}) # ., .. remove
        # echo ${file_list}
        echo ${name}
        current=`echo "./${name}"`
        dot=`echo "${HOME}/${name}"`
        diff -r -u ${current} ${dot} > ${dtxt}
        if [ ! -s ./${dtxt} ]; then
          echo -e "\033[0;32mno diff\033[0;39m"
        else
          echo -e "\033[0;31mdiff\033[0;39m"
          patch -u -p 2 -d ${current} < ${dtxt}
        fi
    fi
done

rm ${dtxt}

return
