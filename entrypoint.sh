#!/bin/sh
# entrypoint.sh
nohup v2ray run -c /etc/v2ray/config.json >/dev/null 2>&1 &
echo "V2ray 已经运行。。。"
sleep 5
nohup caddy run -c /etc/caddy/Caddyfile  --adapter caddyfile >/dev/null 2>&1 &
echo "Caddy 已经运行。。。"

# 执行传入的命令（通常是 crond -f）
exec "$@"
