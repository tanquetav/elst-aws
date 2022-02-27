#!/bin/bash
cloud-init status --wait

TOKEN=`cat /tmp/token`

echo Y | /usr/share/elasticsearch/bin/elasticsearch-reconfigure-node  --enrollment-token $TOKEN

systemctl enable elasticsearch
systemctl start elasticsearch