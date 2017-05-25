#!/bin/bash


LOG_FILE_NAME=/home/ubuntu/cogstack-master/demo.log
#LOG_LEVEL=DEBUG
LOG_LEVEL=INFO
#FILE_LOG_LEVEL=DEBUG
LOG_LEVEL=INFO
JAR=/home/ubuntu/cogstack-master/build/libs/cogstack-1.2.0.jar
CONFIGS=/home/ubuntu/cogstack-master/demo-config/

java -DLOG_FILE_NAME=$LOG_FILE_NAME -DLOG_LEVEL=$LOG_LEVEL -DFILE_LOG_LEVEL=$FILE_LOG_LEVEL -jar $JAR $CONFIGS > stdout 2> stderr

