#!/bin/sh
# entrypoint.sh



# 执行传入的命令（通常是 crond -f）
exec "$@"
