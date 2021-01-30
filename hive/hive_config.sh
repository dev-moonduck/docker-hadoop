#!/bin/bash

source /functions.sh

configure /opt/hive/conf/hive-site.xml hive HIVE_SITE_CONF


#/opt/hive/bin/hive --service metastore &
/opt/hive/bin/schematool -dbType postgres -initSchema
