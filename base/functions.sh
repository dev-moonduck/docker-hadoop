#!/bin/bash

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

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

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}
