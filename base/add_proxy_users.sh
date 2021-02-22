#!/bin/bash

source /scripts/functions.sh

function handleUserOptions() {
    local hadoop_username_prefix="HADOOP_USER_NAME_"
    local hadoop_user_opt_prefix="HADOOP_USER_OPT"
    for user in `printenv | grep $hadoop_username_prefix | sed -r "s/^$hadoop_username_prefix.*?=(.+)$/\1/"`; do
        local optEnv="${hadoop_user_opt_prefix}_${user}"
        local opt=${!optEnv}
        if [ "$opt" != "" ]; then
            local -A paramMap
            OLD_IFS=$IFS
            IFS=";"
            local splitOpt=($opt)
            
            for o in ${splitOpt[@]}; do
                local pair=(`echo "$o" | awk -F"=" '{print $1";"$2}'`)
                local pairKey="${pair[0]}"
                local pairValue="${pair[1]}"
                paramMap["$pairKey"]="$pairValue"
            done
            
            if [ "${paramMap[proxy.user]}" = "true" ]; then
                local configForHost="hadoop.proxyuser.${user}.hosts"
                local valueForHost="${paramMap[proxy.hosts]}"
                
                if [ "$valueForHost" = "" ]; then
                    valueForHost="*"
                fi
                local configForGroup="hadoop.proxyuser.${user}.groups"
                local valueForGroup="${paramMap[proxy.groups]}"
                if [ "$valueForGroup" = "" ]; then
                    valueForGroup="*"
                fi
                
                echo "Adding proxy user $configForHost=$valueForHost, $configForGroup=$valueForGroup"
                addProperty /etc/hadoop/core-site.xml "$configForHost" "$valueForHost"
                addProperty /etc/hadoop/core-site.xml "$configForGroup" "$valueForGroup"
            fi
            IFS=$OLD_IFS
        fi
    done
}

handleUserOptions
