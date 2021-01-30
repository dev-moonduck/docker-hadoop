#!/bin/bash

SAFE_MODE_STATUS=`hdfs dfsadmin -safemode get`
if [ "$SAFE_MODE_STATUS" = "Safe mode is ON" ]; then
    echo "Leaving safemode"
    hdfs dfsadmin -safemode leave
fi

# create users in hdfs
# prefix HADOOP_USER_NAME_ will be added in hdfs
hadoop_username_prefix="HADOOP_USER_NAME_"
for user in `printenv | grep $hadoop_username_prefix | sed -r "s/^$hadoop_username_prefix.*?=(.+)$/\1/"`; do
    # split by comma to check if it's proxy user
    user_path_in_hdfs="/user/$user"
    path_exist=`hdfs dfs -ls $user_path_in_hdfs`
    if [ "$path_exist" = "" ]; then
        usergroup=`groups $user`
        if [ "$usergroup" = "" ]; then
            owner=$user
        else
            owner="$user:$usergroup"
        fi
        echo "creating user home $user_path_in_hdfs owned by $owner"
        hdfs dfs -mkdir $user_path_in_hdfs
        hdfs dfs -chown $owner $user_path_in_hdfs
    fi 
done