#!/bin/bash

# hadoop fs -mkdir -p    /tmp
# hadoop fs -mkdir -p    /user/hive/warehouse
# hadoop fs -chmod g+w   /tmp
# hadoop fs -chmod g+w   /user/hive/warehouse

# $HIVE_HOME/bin/schematool -dbType postgres -initSchema

# su --preserve-environment hive -c "cd $HIVE_HOME/bin && ./hive --service metastore" &

# source /functions.sh
# wait_for_it localhost:9083

su --preserve-environment hive -c "JAVA_HOME=$JAVA8_HOME cd $HIVE_HOME/bin && ./hiveserver2"
