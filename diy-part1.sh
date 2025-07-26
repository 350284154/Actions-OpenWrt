#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 删除可能存在的旧插件目录，避免冲突
rm -rf package/luci-app-ssr-plus
rm -rf package/openwrt-passwall
rm -rf package/luci-app-passwall
rm -rf package/luci-app-passwall2
rm -rf package/luci-app-openclash

# 克隆 SSR Plus
echo 'src-git helloworld https://github.com/fw876/helloworld ' >>feeds.conf.default

# 克隆 Passwall 和依赖包
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2

# 克隆 OpenClash（使用 sparse checkout 精准拉取）
git clone --depth=1 --filter=blob:none --sparse https://github.com/vernesong/OpenClash package/luci-app-openclash
cd package/luci-app-openclash
git sparse-checkout set luci-app-openclash
cd -
