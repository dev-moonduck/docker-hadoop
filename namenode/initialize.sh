#!/bin/bash

SAFE_MODE_STATUS=`hdfs dfsadmin -safemode get`
if [ "$SAFE_MODE_STATUS" = "Safe mode is ON" ]; then
    echo "Leaving safemode"
    hdfs dfsadmin -safemode leave
fi
