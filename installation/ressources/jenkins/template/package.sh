#!/bin/bash

echo "################ PACKAGE ################"
DATE=`date +%d-%m-%Y-%H-%M`
tar cvf demo_$DATE.tar demo.sh
curl -v -u "admin:passdemo" --upload-file demo_$DATE.tar http://10.5.0.30:8081/repository/demo/
