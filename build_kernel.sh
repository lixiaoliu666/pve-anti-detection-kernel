#以下两行docker里面运行需要sudo 如果pve里面运行请删除sudo
apt-get update
apt-get install -y libacl1-dev libaio-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libepoxy-dev libfdt-dev libgbm-dev libgnutls28-dev libiscsi-dev libjpeg-dev libnuma-dev libpci-dev libpixman-1-dev libproxmox-backup-qemu0-dev librbd-dev libsdl1.2-dev libseccomp-dev libslirp-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libvirglrenderer-dev meson python3-sphinx python3-sphinx-rtd-theme quilt xfslibs-dev
apt install -y dh-python asciidoc-base bison dwarves flex libdw-dev libelf-dev libiberty-dev libslang2-dev lz4 python3-dev xmlto rsync gawk
ls
df -h
git clone git://git.proxmox.com/git/pve-kernel.git
cd pve-kernel
#git reset --hard 91ca55897a7e9a1451833216479098b05e6bc0f6 # bump version to 6.14.8-2
apt install devscripts -y
mk-build-deps --install
git submodule update --init --recursive --force #强制更新所有子模块
git pull #强制更新到最新版本内核
cd submodules/zfsonlinux/
mk-build-deps --install
cd ../..
sed -i 's/kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);/if (KVM_GUESTDBG_SINGLESTEP ) {\n\t\tprintk(KERN_ALERT "kvm_vcpu_do_singlestep if (KVM_GUESTDBG_SINGLESTEP)  lixiaoliu666 and dds666 return 0\\n"); \n\t\tkvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW | 1;\n\t\tkvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);\n\t\tkvm_run->debug.arch.exception = DB_VECTOR;\n\t\tkvm_run->exit_reason = KVM_EXIT_DEBUG;\n\t\treturn 0;\n\t}\n\tkvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);/g' submodules/ubuntu-kernel/arch/x86/kvm/x86.c # Checking hypervisor interception...
sed -i 's/kvm_init_xstate_sizes/printk(KERN_ALERT "kvm.ko lixiaoliu666 and dds666 v2.0 Start,ok!!!\\n");\n\tkvm_init_xstate_sizes/g' submodules/ubuntu-kernel/arch/x86/kvm/x86.c # start lixiaoliu666 flag

sed -i '/CPU_BASED_RDTSC_EXITING/d' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.h
sed -i 's/CPU_BASED_TPR_SHADOW/(CPU_BASED_TPR_SHADOW/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.h
sed -i 's/CPU_BASED_INTR_WINDOW_EXITING/CPU_BASED_RDTSC_EXITING |					\\\n\t CPU_BASED_INTR_WINDOW_EXITING/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.h

sed -i 's/static int vmx_setup_l1d_flush/static __always_inline u64 mul_u64_u64_shr0(u64 a, u64 mul, unsigned int shift){	return (u64)(((unsigned __int128)a \* mul) >> shift); }\nstatic inline u64 __scale_tsc0(u64 ratio, u64 tsc){	return mul_u64_u64_shr0(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits); }\nstatic inline u64 kvm_scale_tsc0(u64 tsc, u64 ratio){\n\tu64 _tsc = tsc;\n\tif (ratio != kvm_caps.default_tsc_scaling_ratio){_tsc = __scale_tsc0(ratio, tsc);}\n\treturn _tsc;\n}\nstatic int vmx_setup_l1d_flush/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c
sed -i 's/exec_control \&= ~(CPU_BASED_RDTSC_EXITING |/exec_control \&= ~(/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c
sed -i 's/\/\* INTR_WINDOW_EXITING/exec_control |= CPU_BASED_RDTSC_EXITING; \/\/Ensure handle_rdtsc() is used.added line lixiaoliu666 and dds666\n\t\/\* INTR_WINDOW_EXITING/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c
sed -i 's/static int handle_notify/static u32 print_once_rdtsc = 1;\nstatic int handle_rdtsc(struct kvm_vcpu \*vcpu) {\n\tu64 offset = vcpu->arch.tsc_offset;\n\tu64 ratio = vcpu->arch.tsc_scaling_ratio;\n\tu64 rdtsc_fake;\n\tif(print_once_rdtsc){\n\t\tprintk(KERN_ALERT "[handle_rdtsc] vmx.c fake rdtsc vmx function is working lixiaoliu666 and dds666\\n");\n\t\tprint_once_rdtsc = 0;\n\t}\n\tif (vmx_get_cpl(vcpu) != 0 || !is_protmode(vcpu)){ratio \/= 4;}\n\trdtsc_fake = kvm_scale_tsc0(rdtsc(), ratio) + offset;\n\tvcpu->arch.regs[VCPU_REGS_RAX] = rdtsc_fake \& -1u;\n\tvcpu->arch.regs[VCPU_REGS_RDX] = (rdtsc_fake >> 32) \& -1u;\n\treturn skip_emulated_instruction(vcpu);\n}\nstatic u32 print_once_rdtscp = 1;\nstatic int handle_rdtscp(struct kvm_vcpu \*vcpu) {\n\tif(print_once_rdtscp){\n\t\tprintk(KERN_ALERT "[handle_rdtscp] vmx.c fake rdtscp vmx function is working lixiaoliu666 and dds666\\n");\n\t\tprint_once_rdtscp = 0;\n\t}\n\tvcpu->arch.regs[VCPU_REGS_RCX] = vmcs_read16(VIRTUAL_PROCESSOR_ID);\n\treturn handle_rdtsc(vcpu);\n}\nstatic int handle_notify/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c
sed -i 's/handle_notify,/handle_notify,\n\t[EXIT_REASON_RDTSC]                   = handle_rdtsc, \/\/added line lixiaoliu666 and dds666\n\t[EXIT_REASON_RDTSCP]                  = handle_rdtscp, \/\/added line lixiaoliu666 and dds666/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c
sed -i 's/int r, cpu;/int r, cpu;\n\tprintk(KERN_ALERT "kvm-intel.ko lixiaoliu666 and dds666 v2.0 Start,ok!!!\\n");\/\/added line lixiaoliu666 and dds666/g' submodules/ubuntu-kernel/arch/x86/kvm/vmx/vmx.c


sed -i 's/svm_set_intercept(svm, INTERCEPT_RSM);/svm_set_intercept(svm, INTERCEPT_RSM);\n\tsvm_set_intercept(svm, INTERCEPT_RDTSC); \/\/added line lixiaoliu666 and dds666/g' submodules/ubuntu-kernel/arch/x86/kvm/svm/svm.c
sed -i 's/avic_unaccelerated_access_interception,/avic_unaccelerated_access_interception,\n\t[SVM_EXIT_RDTSC]			= handle_rdtsc_interception, \/\/added line lixiaoliu666 and dds666/g' submodules/ubuntu-kernel/arch/x86/kvm/svm/svm.c
sed -i 's/static int (\*const svm_exit_handlers/static u32 print_once = 1;\nstatic int handle_rdtsc_interception(struct kvm_vcpu \*vcpu){\n\tstatic u64 rdtsc_fake = 0;\n\tstatic u64 rdtsc_prev = 0;\n\tu64 rdtsc_real = rdtsc();\n\tif(print_once){\n\t\tprintk(KERN_ALERT "[handle_rdtsc] svm.c fake rdtsc svm function is working lixiaoliu666 and dds666\\n");\n\t\tprint_once = 0;\n\t\trdtsc_fake = rdtsc_real;\n\t}\n\tif(rdtsc_prev != 0){\n\t\tif(rdtsc_real > rdtsc_prev){\n\t\t\tu64 diff = rdtsc_real - rdtsc_prev;\n\t\t\tu64 fake_diff =  diff \/ 20; \/\/ if you have 3.2Ghz on your vm, change 20 to 16\n\t\t\trdtsc_fake += fake_diff;\n\t\t}\n\t}\n\tif(rdtsc_fake > rdtsc_real){rdtsc_fake = rdtsc_real;}\n\trdtsc_prev = rdtsc_real;\n\tvcpu->arch.regs[VCPU_REGS_RAX] = rdtsc_fake \& -1u;\n\tvcpu->arch.regs[VCPU_REGS_RDX] = (rdtsc_fake >> 32) \& -1u;\n\treturn svm_skip_emulated_instruction(vcpu);\n}\nstatic int (\*const svm_exit_handlers/g' submodules/ubuntu-kernel/arch/x86/kvm/svm/svm.c
sed -i 's/__unused_size_checks/printk(KERN_ALERT "kvm-amd.ko lixiaoliu666 and dds666 v2.0 Start,ok!!!\\n");\/\/added line lixiaoliu666 and dds666\n\t__unused_size_checks/g' submodules/ubuntu-kernel/arch/x86/kvm/svm/svm.c
cd submodules/ubuntu-kernel/
git diff > qemu-autoGenPatch.patch
cp qemu-autoGenPatch.patch ../..
cd ../..
#make build-dir-fresh
make
