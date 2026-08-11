#!/bin/bash
echo "SPARK_WORKLOAD: $SPARK_WORKLOAD"

if [ "$SPARK_WORKLOAD" == "master" ]; 
then
  start-master.sh -p 7077
  pyspark
elif [ "$SPARK_WORKLOAD" == "worker" ]; 
then
  start-worker.sh spark://spark-master:7077
elif [ "$SPARK_WORKLOAD" == "history" ]; 
then
  start-history-server.sh
else 
  jupyter  --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=tanvianuj
fi