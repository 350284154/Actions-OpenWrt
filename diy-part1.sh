#!/bin/bash
# https://github.com/P3TERX/Actions-OpenWrt
# File: diy-part1.sh
# Description: Add fw876/helloworld repository for luci-app-ssr-plus.

set -euo pipefail

# 1. 确保 package 目录存在
mkdir -p package

# 2. 克隆 fw876/helloworld 仓库到 package 目录
# 使用 --depth 1 进行浅克隆，以节省云编译的空间和时间
echo "[diy-part1] Cloning fw876/helloworld into package/helloworld..."
if [ ! -d package/helloworld ]; then
    git clone --depth 1 https://github.com/fw876/helloworld.git package/helloworld
else
    echo "[diy-part1] package/helloworld already exists, skipping clone."
fi

echo "[diy-part1] Done: fw876/helloworld added."
