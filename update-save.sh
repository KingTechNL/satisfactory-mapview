#!/bin/bash
latest_file=$(ls -t /saves | grep -v 'latest.sav' | head -n 1)

current_datetime=$(date +"[%Y-%m-%d %H:%M:%S]")

out_ln=$(ln -vsf "./$latest_file" /saves/${SAVE_NAME})

echo "$current_datetime $out_ln"
