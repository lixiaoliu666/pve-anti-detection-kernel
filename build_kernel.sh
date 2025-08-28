#以下两行docker里面运行需要sudo 如果pve里面运行请删除sudo
sudo apt-get update
sudo apt-get install -y libacl1-dev libaio-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libepoxy-dev libfdt-dev libgbm-dev libgnutls28-dev libiscsi-dev libjpeg-dev libnuma-dev libpci-dev libpixman-1-dev libproxmox-backup-qemu0-dev librbd-dev libsdl1.2-dev libseccomp-dev libslirp-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libvirglrenderer-dev meson python3-sphinx python3-sphinx-rtd-theme quilt xfslibs-dev
sudo apt install -y dh-python asciidoc-base bison dwarves flex libdw-dev libelf-dev libiberty-dev libslang2-dev lz4 python3-dev xmlto
ls
df -h
git clone git://git.proxmox.com/git/pve-kernel.git
cd pve-kernel
git reset --hard 91ca55897a7e9a1451833216479098b05e6bc0f6 # bump version to 6.14.8-2
apt install devscripts -y
mk-build-deps --install
make
