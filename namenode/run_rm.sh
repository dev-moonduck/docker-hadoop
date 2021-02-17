#!/bin/bash

source /functions.sh

dependencies=("namenode1:9870" "namenode2:9870")

for d in "${dependencies[@]}"; do
    wait_for_it $d
done

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
