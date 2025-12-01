#!/bin/sh
# entrypoint.sh


v2ray run -c /etc/v2ray/config.json

# 执行传入的命令（通常是 crond -f）
exec "$@"
