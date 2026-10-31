#!/bin/bash
# Actions 配额不足时在 Ubuntu 22.04/24.04 x86_64 虚拟机里本地编译
# 建议：≥4 核、≥8GB 内存、≥80GB 磁盘；不要用 root 运行
# 用法: bash scripts/local-build.sh [menuconfig]
set -euo pipefail
[ "$(id -u)" = 0 ] && { echo "请用普通用户运行"; exit 1; }

HERE="$(cd "$(dirname "$0")/.." && pwd)"
WORK="${WORK:-$HOME/lede}"

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git \
  libncurses5-dev libssl-dev python3 python3-setuptools python3-pyelftools rsync swig \
  unzip zlib1g-dev file wget curl ccache device-tree-compiler libelf-dev xxd

if [ -d "$WORK/.git" ]; then
  git -C "$WORK" reset --hard -q && git -C "$WORK" pull --ff-only
else
  git clone --depth 1 https://github.com/coolsnowwolf/lede "$WORK"
fi
cd "$WORK"

bash "$HERE/scripts/diy-part1.sh"
./scripts/feeds update -a
bash "$HERE/scripts/diy-part2.sh"
./scripts/feeds install -a
./scripts/feeds install -a -f -p nikki

cp "$HERE/config/m68s-plus.config" .config
make defconfig
[ "${1:-}" = menuconfig ] && make menuconfig

for s in CONFIG_TARGET_rockchip_armv8_DEVICE_ezpro_mrkaio-m68s-plus CONFIG_PACKAGE_firewall4 \
         CONFIG_PACKAGE_kmod-nft-tproxy CONFIG_PACKAGE_nikki CONFIG_PACKAGE_luci-app-nikki; do
  grep -q "^$s=y" .config || { echo "ERROR: $s 未启用"; exit 1; }
done

make download -j8
make -j"$(nproc)" || make -j1 V=s

ls -lh bin/targets/rockchip/armv8/*ezpro_mrkaio-m68s-plus*sysupgrade.img.gz
