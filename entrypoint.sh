#!/bin/sh
# entrypoint.sh

caddy run -c /etc/caddy/Caddyfile
echo "Caddy 已经运行。。。"
sleep 5
v2ray run -c /etc/v2ray/config.json
echo "V2ray 已经运行。。。"
# 执行传入的命令（通常是 crond -f）
exec "$@"
