#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认 IP 地址
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 添加 SSR Plus 配置到 .config
cat >> .config <<'EOF'
# LuCI
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-compat=y

# SSR Plus
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_shadowsocks-libev-ss-local=y
CONFIG_PACKAGE_shadowsocks-libev-ss-redir=y
CONFIG_PACKAGE_xray-core=y
CONFIG_PACKAGE_chinadns-ng=y
CONFIG_PACKAGE_dns2socks=y
CONFIG_PACKAGE_ipt2socks=y
CONFIG_PACKAGE_microsocks=y

# 禁用 Rust 相关包，避免拉起 Rust 工具链
CONFIG_PACKAGE_tuic-client=n
CONFIG_PACKAGE_shadowsocks-rust-sslocal=n
CONFIG_PACKAGE_shadowsocks-rust-ssserver=n
CONFIG_PACKAGE_dns2socks-rust=n
EOF

# 重新整理配置
make defconfig

