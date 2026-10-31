#!/bin/bash
# 在 ./scripts/feeds update -a 之后、feeds install 之前执行
set -euo pipefail

# packages 源里也有一个同名 mihomo 包；删掉它，让 nikki 的 +mihomo 依赖由 mihomo-meta (PROVIDES:=mihomo) 满足
rm -rf feeds/packages/net/mihomo
./scripts/feeds update -i packages

# 可选：修改默认 LAN IP
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
