#!/bin/bash
# This script run cluster components in order
# All components is required to install agent.py in /scripts
# FYI agent.py is in base image
# TODO: Use puppet as modern approach

source /functions.sh

AGENT_PORT=3333

function run_remote_script() 
{
    local target_node=$1
    local target_script=$2
    echo "Running $target_script in $target_node..."
    curl -XPOST -s "http://${target_node}${target_script}" || exit -1
}

function wait_agent()
{
    local agent_addr=$1
    wait_for_it $agent_addr
    echo "Agent in $agent_addr is now running!"
}

# Run Journal Node
echo "Trying to run Journal nodes..."
JOURNAL_RUN_SCRIPT="/scripts/run_journal.sh"
JOURNAL_NODES=("journal1.hadoop" "journal2.hadoop" "journal3.hadoop")
JOURNAL_PORT=8485
for node in "${JOURNAL_NODES[@]}"; do
    agent_addr="$node:$AGENT_PORT"
    wait_agent $agent_addr
    run_remote_script $agent_addr $JOURNAL_RUN_SCRIPT
done

for node in "${JOURNAL_NODES[@]}"; do
    wait_for_it "$node:$JOURNAL_PORT"
done
echo "All journal have been up!"

# Run Zookeeper
echo "Trying to run Zookeeper..."
ZOOKEEPER_RUN_SCRIPT="/scripts/run_zookeeper.sh"
ZOOKEEPER_NODES=("zk1.hadoop" "zk2.hadoop" "zk3.hadoop")
ZOOKEEPER_PORT=2181
for node in "${ZOOKEEPER_NODES[@]}"; do
    agent_addr="$node:$AGENT_PORT"
    wait_agent $agent_addr
    run_remote_script $agent_addr $ZOOKEEPER_RUN_SCRIPT
done

for node in "${ZOOKEEPER_NODES[@]}"; do
    wait_for_it "$node:$ZOOKEEPER_PORT"
done
echo "All zookeeper have been up!"

# Run Namenodes
NAMENODE_PORT=9000
# Run Active Namenode
echo "Trying to run namenode(active)..."
ACTIVE_NAMENODE="namenode1"
STANDBY_NAMENODE="namenode2"
nn1_agent_addr="$ACTIVE_NAMENODE:$AGENT_PORT"
wait_agent $nn1_agent_addr
run_remote_script $nn1_agent_addr "/scripts/run_active_nn.sh"
wait_for_it "$ACTIVE_NAMENODE:$NAMENODE_PORT"

# Run Standby Namenode
echo "Trying to run namenode(standby)..."
nn2_agent_addr="$STANDBY_NAMENODE:$AGENT_PORT"
wait_agent $nn2_agent_addr
run_remote_script $nn2_agent_addr "/scripts/run_standby_nn.sh"
wait_for_it "$STANDBY_NAMENODE:$NAMENODE_PORT"
echo "All namenode have been up!"

# Run Datanodes and node manager
DATANODE_PORT=9864
NODEMANAGER_PORT=8042
echo "Trying to run datanode/nodemanager..."
DATA_NODES=("datanode1" "datanode2" "datanode3" "datanode4" "datanode5" "datanode6" "datanode7")
for node in "${DATA_NODES[@]}"; do
    agent_addr="$node:$AGENT_PORT"
    wait_agent $agent_addr
    run_remote_script $agent_addr "/scripts/run_datanode.sh"
    run_remote_script $agent_addr "/scripts/run_nodemanager.sh"
done
for node in "${DATA_NODES[@]}"; do
    wait_for_it "$node:$DATANODE_PORT"
    wait_for_it "$node:$NODEMANAGER_PORT"
done
echo "All datanode/nodemanager have been up!"

# Run Resourcemanager
RM_PORT=8088
RM_ADDR="resourcemanager"
echo "Trying to run resourcemanager..."
agent_addr="$RM_ADDR:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_rm.sh"
wait_for_it "$RM_ADDR:$RM_PORT"
echo "Resource manager has been up!"

# Run Hive metastore
wait_for_it "cluster-db:5432" # Wait until metastore db up
HMS_HOST="hive-metastore"
HMS_PORT=9083
echo "Trying to run hive-metastore..."
agent_addr="$HMS_HOST:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_hive_metastore.sh"
# Check HMS later to avoid block next execution

# Run Yarn HistoryServer
YARN_HS_ADDR="yarn-historyserver"
YARN_HS_PORT=8188
echo "Trying to run yarn historyserver..."
agent_addr="$YARN_HS_ADDR:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_yarn_hs.sh"

# Run Spark HistoryServer
SPARK_HS_ADDR="spark-historyserver"
SPARK_HS_PORT=8188
echo "Trying to run spark historyserver..."
agent_addr="$SPARK_HS_ADDR:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_spark_hs.sh"

wait_for_it "$YARN_HS_ADDR:$YARN_HS_PORT"
echo "Yarn history server has been up!"

wait_for_it "$SPARK_HS_ADDR:$SPARK_HS_PORT"
echo "Spark history server has been up!"

wait_for_it "$HMS_HOST:$HMS_PORT"
echo "Hive metastore has been up!"

# Run hive server
HIVE_SERVER_ADDR="hive-server"
HIVE_SERVER_PORT=10000
echo "Trying to run hive server..."
agent_addr="$HIVE_SERVER_ADDR:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_hive_server.sh"
wait_for_it "$HIVE_SERVER_ADDR:$HIVE_SERVER_PORT"
echo "Hive server has been up!"

# Run Spark thrift server
SPARK_THRIFT_ADDR="spark-adhoc"
SPARK_THRIFT_PORT=4040
echo "Trying to run spark thrift server..."
agent_addr="$SPARK_THRIFT_ADDR:$AGENT_PORT"
wait_agent $agent_addr
run_remote_script $agent_addr "/scripts/run_spark_thrift_server.sh"
wait_for_it "$SPARK_THRIFT_ADDR:$SPARK_THRIFT_PORT"
echo "Spark thrift server has been up!"
