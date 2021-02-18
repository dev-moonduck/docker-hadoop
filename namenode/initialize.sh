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
        owner="$user:$user"
        echo "creating user home $user_path_in_hdfs owned by $owner"
        hdfs dfs -mkdir -p $user_path_in_hdfs
        hdfs dfs -chown $owner $user_path_in_hdfs
    fi 
done

# upload files as described in upload.csv
while read -r line; do
    if [ "$line" != "" ]; then
        local_file=`echo "$line" | cut -d"," -f1`
        hdfs_path=`echo "$line" | cut -d"," -f2`

        hadoop fs -mkdir -p $hdfs_path
        hadoop fs -copyFromLocal $local_file $hdfs_path
        echo "Local file $local_file has been uploaded to $hdfs_path in HDFS"
    fi
done < /initialization/upload.csv