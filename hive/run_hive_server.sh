#!/bin/bash

su --preserve-environment hive -c "cd $HIVE_HOME/bin && JAVA_HOME=$JAVA8_HOME ./hiveserver2"
