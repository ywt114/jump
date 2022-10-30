# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (放在安装feeds之后)

# 修改管理地址
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 强制切换内核版本
sed -i "s/KERNEL_PATCHVER:=*.*/KERNEL_PATCHVER:=5.10/g" target/linux/x86/Makefile
sed -i "s/KERNEL_TESTING_PATCHVER:=*.*/KERNEL_TESTING_PATCHVER:=5.10/g" target/linux/x86/Makefile

# 交换LAN/WAN口
sed -i 's/"eth1 eth2" "eth0"/"eth1 eth2 eth3" "eth0"/g' target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/'eth1 eth2' 'eth0'/'eth1 eth2 eht3' 'eth0'/g" target/linux/x86/base-files/etc/board.d/02_network

# 修改默认皮肤
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 修改主机名以及一些显示信息
sed -i "s/hostname='*.*'/hostname='JUMP'/" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_ID='*.*'/DISTRIB_ID='OpenWrt'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt'/g"  package/base-files/files/etc/openwrt_release
sed -i '/(<%=pcdata(ver.luciversion)%>)/a\      built by JUMP' package/lean/autocore/files/x86/index.htm
echo "$(date +'%m.%d.%Y')" > package/base-files/files/etc/openwrt_version

# 修改部分默认设置
sed -i "s/option check_signature/# option check_signature/g" package/system/opkg/Makefile
echo "src/gz openwrt_kenzok8 https://op.dllkids.xyz/packages/x86_64" >> package/system/opkg/files/customfeeds.conf
sed -i "s/mirrors.cloud.tencent.com\/lede/mirrors.cloud.tencent.com\/openwrt/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i 's\/root::0:0:99999:7:::/# sed -i 's\/root::0:0:99999:7:::/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i '\/REDIRECT --to-ports/# sed -i '\/REDIRECT --to-ports/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo 'iptables -t/echo '# iptables -t/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo '\[ -n/echo '# \[ -n/g" package/lean/default-settings/files/zzz-default-settings

# 开启wifi选项
sed -i 's/disabled=*.*/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ssid=*.*/ssid=JUMP/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 添加关机按钮到系统选项
curl -fsSL https://raw.githubusercontent.com/ywt114/poweroff/main/poweroff.htm > feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_system/poweroff.htm
curl -fsSL https://raw.githubusercontent.com/ywt114/poweroff/main/system.lua > feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua

# 删除替换默认源插件
rm -rf feeds/packages/lang/golang
git clone -b 19.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
rm -rf feeds/packages/net/smartdns
git clone https://github.com/pymumu/openwrt-smartdns feeds/packages/net/smartdns
rm -rf feeds/packages/net/adguardhome
svn export https://github.com/kenzok8/openwrt-packages/trunk/adguardhome feeds/packages/net/adguardhome

# 添加插件
cd package/lean
git clone https://github.com/ywt114/luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-autotimeset
git clone https://github.com/sbwml/luci-app-alist
git clone https://github.com/rufengsuixing/luci-app-autoipsetadder
git clone -b lede https://github.com/pymumu/luci-app-smartdns
git clone https://github.com/jerrykuku/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr
git clone https://github.com/fw876/helloworld
git clone https://github.com/vernesong/OpenClash
git clone https://github.com/xiaorouji/openwrt-passwall
git clone -b luci https://github.com/xiaorouji/openwrt-passwall passwall/
\cp -rf helloworld/* openwrt-passwall/
rm -rf helloworld
git clone https://github.com/xiangfeidexiaohuo/openwrt-packages
\cp -rf openwrt-packages/op-homebox .
rm -rf openwrt-packages/op-socat/socat
\cp -rf openwrt-packages/op-socat .
rm -rf openwrt-packages
git clone https://github.com/kenzok8/openwrt-packages
\cp -rf openwrt-packages/luci-app-adguardhome .
rm -rf openwrt-packages
git clone https://github.com/linkease/istore
sed -i 's/+luci-lib-ipkg/+luci-base/g' istore/luci/luci-app-store/Makefile
