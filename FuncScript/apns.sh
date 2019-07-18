#!/bin/bash

# 来自于 http://mrpeak.cn/blog/ios-debug-apn/

system_profiler SPUSBDataType | sed -n -E 's/Serial Number: (.+)/\1/1p' | xargs rvictl -s | sudo tcpdump -i rvi0 src port 5223 or https
