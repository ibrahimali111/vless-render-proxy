#!/usr/bin/env bash
set -e

# Read environment variables with fallback defaults
UUID="${UUID:-de04add9-5c68-8bab-950c-08cd5320df18}"
WSPATH="${WSPATH:-/vless-ws}"
PORT="${PORT:-10000}"

# Ensure WSPATH starts with a leading slash
if [[ "${WSPATH:0:1}" != "/" ]]; then
  WSPATH="/${WSPATH}"
fi

echo "========================================="
echo " Starting VLESS WebSocket Proxy Server   "
echo " Port:           ${PORT}"
echo " WebSocket Path: ${WSPATH}"
echo " UUID:           ${UUID}"
echo "========================================="

# Dynamically generate /app/config.json
cat <<EOF > /app/config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "level": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${WSPATH}"
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

# Validate JSON syntax with jq
if command -v jq >/dev/null 2>&1; then
  jq . /app/config.json >/dev/null
fi

# Execute Xray-core
exec /app/xray -config /app/config.json
