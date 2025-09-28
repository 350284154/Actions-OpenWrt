#!/bin/bash
# https://github.com/P3TERX/Actions-OpenWrt
# File: diy-part1.sh
# Description: run before "scripts/feeds update -a"

set -euo pipefail

FEEDS_FILE="feeds.conf.default"

# 1) 在文件开头插入 kenzo / small 源（防重复、可多次执行）
add_feed_top() {
  local name="$1" url="$2"
  if ! grep -qE "^\s*src-git\s+${name}\b" "$FEEDS_FILE"; then
    # 逐条插到最顶端，保持 kenzo 在 small 之上
    sed -i "1i src-git ${name} ${url}" "$FEEDS_FILE"
  fi
}

add_feed_top "small" "https://github.com/kenzok8/small"
add_feed_top "kenzo" "https://github.com/kenzok8/openwrt-packages"

# 2) 更新 feeds
./scripts/feeds update -a

# 3) 清理你不需要/会冲突的包
rm -rf feeds/luci/applications/luci-app-mosdns || true
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns} || true
rm -rf feeds/packages/utils/v2dat || true

# 4) 固定 golang 到 1.25 分支（适配 sing-box / hysteria 等）
rm -rf feeds/packages/lang/golang
git clone --depth=1 -b 1.25 https://github.com/kenzok8/golang feeds/packages/lang/golang

# 5) 安装所有 feeds
./scripts/feeds install -a

echo "[diy-part1] Done: kenzo/small added, feeds updated, cleaned, golang=1.25."
