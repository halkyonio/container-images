#!/bin/bash

java -XX:+UseParallelOldGC \
     -XX:MinHeapFreeRatio=10 \
     -XX:MaxHeapFreeRatio=20 \
     -XX:GCTimeRatio=4 \
     -XX:AdaptiveSizePolicyWeight=90 \
     -XX:MaxMetaspaceSize=100m \
     -XX:+ExitOnOutOfMemoryError \
     -cp "." -jar /usr/src/${CONTEXTPATH}/${MODULEDIRNAME}/target/*.jar