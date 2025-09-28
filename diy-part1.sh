#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

set -e

# 确保在 feeds.conf.default 顶部添加 kenzo / small 两个源（若已存在则不重复添加）
FEEDS_FILE="feeds.conf.default"

# 先去掉可能已存在的重复行（避免多次运行堆叠）
sed -i '/src-git kenzo https:\/\/github.com\/kenzok8\/openwrt-packages/d' "$FEEDS_FILE"
sed -i '/src-git small https:\/\/github.com\/kenzok8\/small/d' "$FEEDS_FILE"

# 在文件开头插入（保持优先级）
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' "$FEEDS_FILE"
sed -i '2i src-git small https://github.com/kenzok8/small' "$FEEDS_FILE"

echo "[diy-part1] 已写入 feeds 源：kenzo / small"
echo "[diy-part1] 本脚本不进行 feeds update/install；请让工作流后续步骤执行。"

# 说明：
# 1) 不拉取 Passwall/OpenClash，完全按你的新要求精简。
# 2) 不固定 golang 1.25（避免 bootstrap 版本不匹配导致的编译失败）。
#    如需用 kenzok8 的 golang，请在 diy-part2.sh（feeds update 之后）替换：
#      rm -rf feeds/packages/lang/golang
#      git clone --depth=1 https://github.com/kenzok8/golang feeds/packages/lang/golang
