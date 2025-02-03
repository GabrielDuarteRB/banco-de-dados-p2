#!/bin/bash
set -e

cp /home/barman/.ssh/id_rsa.pub /home/barman/.ssh/authorized_keys

#service barman start

tail -f /dev/null