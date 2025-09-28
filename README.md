# pve-anti-detection-kernel
PVE virtual machine emulates a physical machine to avoid(or anti) detection kernel or kvm.so（pve虚拟机模拟真实机器防检测内核或kvm模块）

modprobe: ERROR: could not insert 'kvm': Key was rejected by service 如果有这个问题请关闭安全引导后重启pve。

**目前已知问题不知道怎么解决：kvm-intel.ko和kvm-amd.ko加载了打开什么软件都感觉淡入淡出，远程连不上，ssh不上，网页经常说时间快了，所以不发布这两个模块**

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=lixiaoliu666/pve-anti-detection-kernel&type=Date)](https://www.star-history.com/#lixiaoliu666/pve-anti-detection-kernel&Date)
