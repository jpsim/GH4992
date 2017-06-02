#!/bin/sh

ipconfig getifaddr $(netstat -f inet -rant | awk '/default/ { print $6; exit }')
