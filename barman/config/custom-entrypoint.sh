#!/bin/bash
set -e

sleep 20

barman cron

sleep 5

barman switch-wal --force --archive all


sleep infinity 