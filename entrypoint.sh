#!/bin/sh
# entrypoint.sh
env

# 使用环境变量生成新的配置文件
if [ -z "$DOMAIN" ]; then
 DOMAIN=$RAILWAY_PUBLIC_DOMAIN
fi
if [ -z "$UUID" ]; then
 UUID='6e7e4fc7-198e-4f17-8bbf-0dacfc8f8d4d'
fi
REGION=$(echo $RAILWAY_REPLICA_REGION |cut -d'-' -f1,2)
NAME=$(echo $DOMAIN |cut -d'.' -f1)
TITLE="${NAME}-${REGION}"

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

ADDRESS=$DOMAIN
if [[ $DOMAIN != *railway.app ]];then 
 ADDRESS="ip.sb"
fi
VMESS=$(
cat <<EOF |base64 |tr -d '\n'
{
  "v": "2",
  "ps": "${TITLE}",
  "add": "$ADDRESS",
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

if [[ $DOMAIN != *railway.app ]];then 
  cat <<EOF >>"/usr/share/caddy/$UUID.html"
  <a href="/addCFIP.html">CF域名：CFIP扩展节点</a>
  EOF
fi

echo
echo "访问:"
echo "https://$DOMAIN/$UUID.html"
echo ""
echo "vmess://$VMESS"
echo

nohup v2ray run -c /etc/v2ray/config.json >/dev/null 2>&1 &
echo "V2ray 已经运行。。。"
sleep 5
nohup caddy run -c /etc/caddy/Caddyfile  --adapter caddyfile >/dev/null 2>&1 &
echo "Caddy 已经运行。。。"


# 执行传入的命令（通常是 crond -f）
exec "$@"
