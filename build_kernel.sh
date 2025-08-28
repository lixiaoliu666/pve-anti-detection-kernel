#以下两行docker里面运行需要sudo 如果pve里面运行请删除sudo
apt-get update
apt-get install -y libacl1-dev libaio-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libepoxy-dev libfdt-dev libgbm-dev libgnutls28-dev libiscsi-dev libjpeg-dev libnuma-dev libpci-dev libpixman-1-dev libproxmox-backup-qemu0-dev librbd-dev libsdl1.2-dev libseccomp-dev libslirp-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libvirglrenderer-dev meson python3-sphinx python3-sphinx-rtd-theme quilt xfslibs-dev
apt install -y dh-python asciidoc-base bison dwarves flex libdw-dev libelf-dev libiberty-dev libslang2-dev lz4 python3-dev xmlto rsync gawk
ls
df -h
git clone git://git.proxmox.com/git/pve-kernel.git
cd pve-kernel
git reset --hard 91ca55897a7e9a1451833216479098b05e6bc0f6 # bump version to 6.14.8-2
apt install devscripts -y
mk-build-deps --install
git submodule update --init --recursive
cd submodules/zfsonlinux/
mk-build-deps --install
cd ../..
sed -i 's/kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);/if (KVM_GUESTDBG_SINGLESTEP ) {\n\t\tprintk(KERN_ALERT "kvm_vcpu_do_singlestep if (KVM_GUESTDBG_SINGLESTEP)  lixiaoliu666 return 0\\n"); \n\t\tkvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW | 1;\n\t\tkvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);\n\t\tkvm_run->debug.arch.exception = DB_VECTOR;\n\t\tkvm_run->exit_reason = KVM_EXIT_DEBUG;\n\t\treturn 0;\n\t}\n\tkvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);/g' submodules/ubuntu-kernel/arch/x86/kvm/x86.c # Checking hypervisor interception...
sed -i 's/kvm_init_xstate_sizes/printk(KERN_ALERT "KVM lixiaoliu666 and dds666 v2.0 Start,ok!!!\\n");\n\tkvm_init_xstate_sizes/g' submodules/ubuntu-kernel/arch/x86/kvm/x86.c # start lixiaoliu666 flag
cd submodules/ubuntu-kernel/
git diff > qemu-autoGenPatch.patch
cp qemu-autoGenPatch.patch ../..
cd ../..
make build-dir-fresh
make
