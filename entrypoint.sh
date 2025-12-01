#!/bin/sh
# entrypoint.sh
nohup v2ray run -c /etc/v2ray/config.json >/dev/null 2>&1 &
echo "V2ray 已经运行。。。"
sleep 5
nohup caddy run -c /etc/caddy/Caddyfile  --adapter caddyfile >/dev/null 2>&1 &
echo "Caddy 已经运行。。。"

# 使用环境变量生成新的配置文件
if [ -z "$DOMAIN" ]; then
	DOMAIN=$(printenv|grep _80_DOMAIN|cut -d"=" -f2)
fi
if [ -z "$UUID" ]; then
	UUID='6e7e4fc7-198e-4f17-8bbf-0dacfc8f8d4d'
fi

cat <<EOF > /etc/v2ray/config.json
{
  "inbounds": [
    {
      "port": 1080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/vmess-ws"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF


VMESS=$(
cat <<EOF |base64 |tr -d '\n'
{
  "v": "2",
  "ps": "$DOMAIN",
  "add": "$DOMAIN",
  "port": "443",
  "id": "$UUID",
  "aid": "0",
  "scy": "none",
  "net": "ws",
  "type": "none",
  "host": "$DOMAIN",
  "path": "/vmess-ws",
  "tls": "tls",
  "sni": "",
  "alpn": "",
  "fp": "chrome",
  "insecure": "1"
}
EOF
)


cat <<EOF >"/usr/share/caddy/$UUID.html"
<pre>

vmess://$VMESS

</pre>
EOF

echo
echo "访问:"
echo "https://$DOMAIN/$UUID.html"
echo ""
echo "vmess://$VMESS"
echo


# 执行传入的命令（通常是 crond -f）
exec "$@"
