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

# 2) 清理你不需要/会冲突的包
# 注意：这些路径是相对 OpenWrt 根目录的路径（在 YML 中，脚本是在 openwrt 目录外执行的，但在脚本内部路径是相对 openwrt 根目录）
# 推荐改为相对路径，因为此时 feeds 可能还未更新
# 在 feeds.conf.default 阶段，这些路径应该不存在，但为了安全保留
rm -rf feeds/luci/applications/luci-app-mosdns || true
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns} || true
rm -rf feeds/packages/utils/v2dat || true

# 3) 移除 Go 语言处理逻辑，交由 YML 脚本管理
# rm -rf feeds/packages/lang/golang
# git clone --depth=1 -b 1.25 https://github.com/kenzok8/golang feeds/packages/lang/golang

# 4) 移除重复的 feeds update / install
# ./scripts/feeds update -a
# ./scripts/feeds install -a

echo "[diy-part1] Done: kenzo/small added and old packages cleaned."
