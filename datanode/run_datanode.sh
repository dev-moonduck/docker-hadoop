#!/bin/bash
# source /functions.sh
# wait_for_it namenode1:9000
# wait_for_it namenode2:9000

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode

# wait_for_it localhost:9864
# echo "Datanode has been up"
