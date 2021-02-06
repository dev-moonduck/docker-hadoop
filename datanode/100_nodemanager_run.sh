#!/bin/bash

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager &
wait_for_it localhost:8042
echo "Nodemanager has been up"