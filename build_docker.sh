#!/bin/bash

# copy the keys into local folder if the id_rsa* files are not in the local directory

ssh_files=("id_rsa" "id_rsa.pub")
index=0

for file_name in ${ssh_files[@]}; do

    if [ ! -f "./$file_name" ] && [ -f "$HOME/.ssh/${file_name}" ]; then
	cp ${HOME}/.ssh/${file_name} ./
	let "index=index+1"
    fi

done

len=${#ssh_files[@]}

if [ $index ne $len ]; then

   echo "The id_rsa and/or id_rsa.pub - not found"
   exit

fi



docker build --build-arg BUILDBOT="iusyk" --build-arg PUB_KEY="${ssh_files[1]}" --build-arg PRIV_KEY="${ssh_files[0]}" --build-arg CONFIG="$5" --build-arg BUILBOT_MAIL="$1" --build-arg BRANCH="$3" --build-arg PROD="$2" --build-arg MACHINE="$4"  -t "$2-image" .

back_pid=$!
wait $back_pid

for file_name in ${ssh_files[@]}; do

    if [ -f "./$file_name" ]; then
        rm ./${file_name}
    fi

done 
