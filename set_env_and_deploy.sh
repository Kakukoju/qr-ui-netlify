#!/bin/bash
echo "🌀 啟動 cloudflared tunnel..."
URL=$(cloudflared tunnel --url http://localhost:5000 2>&1 | tee /dev/tty | grep -oE "https://[a-z0-9-]+\.trycloudflare\.com" | head -n 1)

if [ -z "$URL" ]; then
  echo "❌ 無法擷取公開 URL，請確認 cloudflared 正常執行"
  exit 1
fi

echo "✅ 擷取到公開 URL: $URL"

# 產生 env.js 檔案
echo "window.API_BASE = \"$URL\";" > env.js

echo "✅ 已寫入 env.js"

# 自動 git push（前提是你的 repo 設好了）
echo "📤 推送到 GitHub（Netlify 將自動重新部署）"
git add env.js
git commit -m "Update API_BASE to $URL"
git push
