# EZPRO Mrkaio M68S Plus · LEDE + Nikki 云编译

- 源码：coolsnowwolf/lede master（版本基线 24.10.x，内核 6.18，默认 firewall4 + ucode）
- 机型：`rockchip/armv8` → `ezpro_mrkaio-m68s-plus`（DTS `rk3568-mrkaio-m68s-plus.dts`，驱动 `kmod-r8125-rss`）
- 代理：nikkinikki-org/OpenWrt-nikki（`nikki` + `mihomo-meta` + `luci-app-nikki`）

## GitHub Actions
1. 新建一个 **public** 仓库（public 仓库的 Actions 分钟数不限），把本目录推上去。
2. Settings → Actions → General → Workflow permissions 选 **Read and write**。
3. Actions → *Build M68S-Plus (LEDE + Nikki)* → Run workflow。
4. 约 2–3 小时后从 Artifacts 或 Releases 下载
   `openwrt-rockchip-armv8-ezpro_mrkaio-m68s-plus-squashfs-sysupgrade.img.gz`。

## 本地编译（Ubuntu 22.04/24.04 x86_64 VM）
```bash
git clone <你的仓库> m68s-plus-nikki && cd m68s-plus-nikki
bash scripts/local-build.sh            # 或: bash scripts/local-build.sh menuconfig
```
