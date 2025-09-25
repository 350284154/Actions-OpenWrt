#!/bin/bash
# DIY part2: 在 Update/Install feeds 之后执行（保留现有 .config，仅补丁）

set -e

# ① 修改默认 LAN IP（只改 192.168.1.1 -> 192.168.2.1）
CFG=package/base-files/files/bin/config_generate
[ -f "$CFG" ] && sed -i 's/192\.168\.1\.1/192.168.2.1/g' "$CFG" || true

# ② 辅助函数：若未启用则追加 =y
ensure_y() { grep -q "^$1=y" .config || echo "$1=y" >> .config; }
# 关闭项：删已有行并强制 =n
force_n() { sed -i "/^$1=/d" .config; echo "$1=n" >> .config; }

# ③ 确保 SSR Plus 及常用依赖（全部是 C/Go 实现，不会触发 Rust）
ensure_y CONFIG_PACKAGE_luci
ensure_y CONFIG_PACKAGE_luci-ssl
ensure_y CONFIG_PACKAGE_luci-compat
ensure_y CONFIG_PACKAGE_ca-certificates
ensure_y CONFIG_PACKAGE_wget-ssl
ensure_y CONFIG_PACKAGE_coreutils-nohup

ensure_y CONFIG_PACKAGE_luci-app-ssr-plus
ensure_y CONFIG_PACKAGE_luci-i18n-ssr-plus-zh-cn
ensure_y CONFIG_PACKAGE_xray-core
ensure_y CONFIG_PACKAGE_v2ray-plugin
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-local
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-redir
ensure_y CONFIG_PACKAGE_shadowsocks-libev-ss-server
ensure_y CONFIG_PACKAGE_simple-obfs
ensure_y CONFIG_PACKAGE_dns2socks
# 透明代理常用
ensure_y CONFIG_PACKAGE_ipset
ensure_y CONFIG_PACKAGE_iptables-mod-tproxy
ensure_y CONFIG_PACKAGE_kmod-ipt-tproxy
ensure_y CONFIG_PACKAGE_kmod-ipt-nat

# ④ 彻底关停 Rust 工具链与常见 Rust 包（不同源码命名可能不同，统统禁用）
for k in \
  CONFIG_LANG_RUST \
  CONFIG_PACKAGE_lang-rust \
  CONFIG_PACKAGE_rust \
  CONFIG_PACKAGE_rustup \
  CONFIG_PACKAGE_cargo \
  CONFIG_PACKAGE_shadow-tls \
  CONFIG_PACKAGE_shadow-tls-rust \
  CONFIG_PACKAGE_tuic-client \
  CONFIG_PACKAGE_tuic-server \
  CONFIG_PACKAGE_dns2socks-rust \
  CONFIG_PACKAGE_sing-box-rust \
  CONFIG_PACKAGE_xray-plugin-rust \
  CONFIG_PACKAGE_anytrace-rs \
; do
  force_n "$k"
done

# ⑤ 再保险：把 .config 里含 rust/tuic/shadow/-rs 的包行直接删掉（大小写不敏感）
#    避免某些 profile/默认机型暗带 Rust 包名
sed -i '/rust/I d'   .config
sed -i '/tuic/I d'   .config
sed -i '/shadow/I d' .config
sed -i '/-rs/I d'    .config

# ⑥ 规整配置（按已选项求解依赖）
make defconfig
