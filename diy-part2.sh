#!/bin/bash
set -e

# 改 LAN 默认 IP（仅把 192.168.1.1 改成 192.168.2.1）
CFG=package/base-files/files/bin/config_generate
[ -f "$CFG" ] && sed -i 's/192\.168\.1\.1/192.168.2.1/g' "$CFG" || true

# 小工具
ensure_y() { grep -q "^$1=y" .config || echo "$1=y" >> .config; }
force_n()  { sed -i "/^$1=/d" .config; echo "$1=n" >> .config; }

# 保证你想要的（举例：SSR Plus 常用依赖，按需保留）
ensure_y CONFIG_PACKAGE_luci
ensure_y CONFIG_PACKAGE_luci-ssl
ensure_y CONFIG_PACKAGE_luci-compat
ensure_y CONFIG_PACKAGE_ca-certificates
ensure_y CONFIG_PACKAGE_wget-ssl

# 如果你需要 SSR Plus（不需要就删掉这几行）
ensure_y CONFIG_PACKAGE_luci-app-ssr-plus
ensure_y CONFIG_PACKAGE_luci-i18n-ssr-plus-zh-cn
ensure_y CONFIG_PACKAGE_xray-core
ensure_y CONFIG_PACKAGE_v2ray-plugin
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-local
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-redir
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-server
ensure_y CONFIG_PACKAGE_simple-obfs
ensure_y CONFIG_PACKAGE_dns2socks

# 明确禁止 Rust 语言与常见 Rust 包（不同源码命名可能不同，统统关掉）
for k in \
  CONFIG_LANG_RUST \
  CONFIG_PACKAGE_lang-rust \
  CONFIG_PACKAGE_rust \
  CONFIG_PACKAGE_rustup \
  CONFIG_PACKAGE_cargo \
  CONFIG_PACKAGE_shadow-tls \
  CONFIG_PACKAGE_shadow-tls-rust \
  CONFIG_PACKAGE_tuic \
  CONFIG_PACKAGE_tuic-client \
  CONFIG_PACKAGE_tuic-server \
  CONFIG_PACKAGE_dns2socks-rust \
  CONFIG_PACKAGE_sing-box \
  CONFIG_PACKAGE_sing-box-rust \
  CONFIG_PACKAGE_xray-plugin-rust \
  CONFIG_PACKAGE_anytrace-rs \
; do
  force_n "$k"
done

# 保险：把 .config 里带 rust/tuic/shadow/-rs 的选项直接删掉（大小写不敏感）
sed -i '/rust/I d'   .config
sed -i '/tuic/I d'   .config
sed -i '/shadow/I d' .config
sed -i '/-rs/I d'    .config

# 规整依赖
make defconfig
