#!/bin/bash
# 在 ./scripts/feeds update 之前执行，工作目录 = LEDE 源码根目录
set -euo pipefail

# 1. 注释掉 helloworld (SSR+)，它自带的 mihomo 会和 Nikki 的 mihomo-meta 抢 /usr/bin/mihomo
sed -i 's|^src-git helloworld|#src-git helloworld|' feeds.conf.default

# 2. 追加 Nikki 官方源
grep -q 'OpenWrt-nikki' feeds.conf.default || \
  echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> feeds.conf.default

cat feeds.conf.default
