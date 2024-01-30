# Theory of communication

## SSH

SSH is a powerful tool to allow remote access & control. Through scp, it also allows remote access
to the file system to copy files. For security, we should select a box to use as a base, which is the
only box allowed to SSH to other boxes. This should be an otherwise unused box, which will offer a public
HTTP server offering it's public key for download. All other boxes should then be configured with this
public cert as the only allowed certificate for their SSH server (the base doesn't allow SSH).

## Base Box

To create a secure base box, we need at least one box that doesn't have any existing services running.
Since we cannot rely on the initial config to be secure, we would ideally like to build a fresh linux
image on the box, preventing any existing malware from carrying over.

## Docker

Ideally, we should be able to configure the base as a docker host, 


## Ubuntu Base installation

- rootfs: https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04-base-amd64.tar.gz
- linux-image: http://security.ubuntu.com/ubuntu/pool/main/l/linux-signed-hwe-5.11/linux-image-5.11.0-22-generic_5.11.0-22.23~20.04.1_amd64.deb
- linux-modules: http://security.ubuntu.com/ubuntu/pool/main/l/linux-hwe-5.11/linux-modules-5.11.0-22-generic_5.11.0-22.23~20.04.1_amd64.deb
- linux-base: http://security.ubuntu.com/ubuntu/pool/main/l/linux-base/linux-base_4.5ubuntu3.1_all.deb

- initramfs: http://mirrors.kernel.org/ubuntu/pool/main/i/initramfs-tools/initramfs-tools_0.140ubuntu13_all.deb
- initramfs-core: http://mirrors.kernel.org/ubuntu/pool/main/i/initramfs-tools/initramfs-tools-core_0.140ubuntu13_all.deb
- busybox: http://mirrors.kernel.org/ubuntu/pool/main/b/busybox/busybox-initramfs_1.30.1-7ubuntu3_amd64.deb
- coreutils: http://mirrors.kernel.org/ubuntu/pool/main/c/coreutils/coreutils_8.32-4.1ubuntu1_amd64.deb
- initramfs-bin: http://mirrors.kernel.org/ubuntu/pool/main/i/initramfs-tools/initramfs-tools-bin_0.140ubuntu13_amd64.deb
- klibc-utils: http://mirrors.kernel.org/ubuntu/pool/main/k/klibc/klibc-utils_2.0.10-4_amd64.deb
- klibc: http://mirrors.kernel.org/ubuntu/pool/main/k/klibc/libklibc_2.0.10-4_amd64.deb
- udev: http://mirrors.kernel.org/ubuntu/pool/main/s/systemd/udev_249.11-0ubuntu3_amd64.deb
- zstd: http://mirrors.kernel.org/ubuntu/pool/main/libz/libzstd/zstd_1.4.8+dfsg-3build1_amd64.deb

- initrd: http://mirrors.kernel.org/ubuntu/pool/main/m/microcode-initrd/microcode-initrd_2build1_amd64.deb
- amd: http://mirrors.kernel.org/ubuntu/pool/main/a/amd64-microcode/amd64-microcode_3.20191218.1ubuntu2_amd64.deb
- intel: http://security.ubuntu.com/ubuntu/pool/main/i/intel-microcode/intel-microcode_3.20220809.0ubuntu0.22.04.1_amd64.deb
- iucode: http://mirrors.kernel.org/ubuntu/pool/main/i/iucode-tool/iucode-tool_2.3.1-1build1_amd64.deb
- cpio: http://mirrors.kernel.org/ubuntu/pool/main/c/cpio/cpio_2.13+dfsg-7_amd64.deb

- kmod: http://mirrors.kernel.org/ubuntu/pool/main/k/kmod/kmod_27-1ubuntu2_amd64.deb
- libkmod: http://mirrors.kernel.org/ubuntu/pool/main/k/kmod/libkmod2_27-1ubuntu2_amd64.deb
- libssl1.1: http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

### Installation

untar rootfs into new partition (`swapoff` + reformat swap)
install all packages listed above with `dpkg -i`
run `update-grub` to detect new installation

From here, we have a broken, but bootable system. It appears not to have an init system (likely just need more packages)
However, should we?

### What to do from here?

## Resetter

- https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/add-apt-key_1.0-0.5_all.deb
- https://github.com/gaining/Resetter/releases/download/v3.0.0-stable/resetter_3.0.0-stable_all.deb

(Seems to rely on x11 stuff, impying it's mainly gui)

### Self-created version

1. Install/remove packages to match default installation
2. Generate list of files installed by packages, and check filesystem against this list (`dpkg -L` to list, `dpkg -S` to find package from file)
3. Remove all files not in the list
4. Verify integrety (i.e. reset changed files)

`dpkg-reconfigure` can be used to change debconf configuration parameters. It has a non-interactive mode that can be
used to reset to defaults.
- Just need to clear the existing db, since we don't need it.

We could also clear /etc & /var before reinstalling every package, since it should trigger them to be replaced by
the defaults

`-o Dpkg::Options::="--force-confmiss,confnew,confask"`
`sudo UCF_FORCE_CONFFMISS=1 apt-get --reinstall install [pkgname]`
- These should force dpkg to assume conf files are missing (and install the defaults). (use both to be sure)
- confask marks to ask user no matter what, confnew marks to use the new version (skip actual prompt), confmiss marks to install missing

`sudo debsums -a -s` will show a list of changed config files
- add `-g` to generate sums for packages that don't have one
- should also report permissions errors

NOTE:
  We need to check for any changes (i.e. with debsums) in a default installation, since they need to be handled
  in a special way.

## Other

- Server install iso: https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso

- DSL: https://distro.ibiblio.org/damnsmall/current/dsl-4.4.10.iso

## Minimal package list

ii  apt            0.5.4          Advanced front-end for dpkg
ii  apt-utils      0.5.4          APT utility programs
ii  ash-knoppix    0.2-3          A smaller version of the Bourne shell enhanc
ii  autofs         3.9.99-4.0.0pr A kernel-based automounter for Linux
hc  automount-knop 0.5-3          Auto-generate autofs(5) lines on demand
ii  base-files     3.0.7          Debian base system miscellaneous files
ii  base-passwd    3.4.5          Debian base system password/group files
ii  bash           2.05b-5        The GNU Bourne Again SHell
ii  bsdutils       2.11y-1        Basic utilities from 4.4BSD-Lite.
ii  cdrecord       1.10-7         A command line CD/DVD writing tool
ii  cloop-module   0.67-1         The compressed loopback block device kernel 
ii  cloop-utils    0.67-3         Tools for handling with cloop compressed vol
ii  console-common 0.7.19         Basic infrastructure for text console config
ii  console-data   2002.12.04dbs- Keymaps, fonts, charset maps, fallback table
ii  console-tools- 0.2.3dbs-28    Shared libraries for Linux console and font 
ii  coreutils      4.5.4-1        The GNU core utilities
ii  cpp            2.95.4-17      The GNU C preprocessor.
ii  cpp-2.95       2.95.4-11      The GNU C preprocessor.
ii  csh            20020413-1     Shell with C-like syntax, standard login she
ii  debconf        1.2.21         Debian configuration management system
ii  debianutils    2.1.4          Miscellaneous utilities specific to Debian
ii  deborphan      1.3-1          Find orphaned libraries.
ii  diff           2.8.1-1        File comparison utilities
ii  dpkg           1.10.9         Package maintenance system for Debian
ii  dselect        1.10.9         a user tool to manage Debian packages
ii  e2fsprogs      1.32-1         The EXT2 file system utilities and libraries
ii  fdutils        5.4-20021102-1 Linux floppy utilities
ii  file           3.39-1         Determines file type using "magic" numbers
ii  findutils      4.1.7-2.1      utilities for finding files--find, xargs, an
ii  genliloconf    0.1-3          simple utility for auto-generating of lilo.c
ii  grep           2.4.2-3.1      GNU grep, egrep and fgrep
ii  gzip           1.3.5-3        The GNU compression utility.
ii  hostname       2.09           A utility to set/show the host name or domai
ii  hotplug-knoppi 0.5-1          hotplug handler for KNOPPIX
ii  hwdata-knoppix 0.61-5         hardware identification / configuration data
ii  hwsetup        1.0-11         Automatic hardware setup using the kudzu lib
ii  ifupdown       0.6.4-4.4      High level tools to configure network interf
ii  iputils-ping   20020927-1     Tools to test the reachability of network ho
ii  kbdconfig      0.5-3          Lightweight keyboard configuration tool for 
ii  kernel-image-2 10.00.Custom   Linux kernel binary image for version 2.4.20
ii  less           381-2          A file pager program, similar to more(1)
ii  libbz2         0.9.5d-4       A high-quality block-sorting file compressor
ii  libbz2-1.0     1.0.2-1        A high-quality block-sorting file compressor
ii  libc6          2.3.1-16       GNU C Library: Shared libraries and Timezone
ii  libcap1        1.10-12        support for getting/setting POSIX.1e capabil
ii  libcurl2       7.9.5-1        Multi-protocol file transfer library. (no SS
ii  libdb1-compat  2.1.3-7        The Berkeley database routines [glibc 2.0/2.
ii  libdb2         2.7.7.0-8      The Berkeley database routines (run-time fil
ii  libdb3         3.2.9-17       Berkeley v3 Database Libraries [runtime]
ii  libforms0.88   0.88.1-6       The XForms graphical interface widget librar
ii  libfreetype6   2.1.2-9        FreeType 2 font engine, shared library files
ii  libgdbmg1      1.7.3-27.1     GNU dbm database routines (runtime version).
ii  libglib1.2     1.2.10-6       The GLib library of C routines
ii  libid3tag0     0.14.2b-4      ID3 tag reading library from the MAD project
ii  libldap2       2.0.23-14      OpenLDAP libraries (without TLS support).
ii  libncurses5    5.3.20021109-2 Shared libraries for terminal handling
ii  libnewt0       0.50.17-12     Not Erik's Windowing Toolkit - text mode win
ii  libpam-modules 0.76-9         Pluggable Authentication Modules for PAM
ii  libpam-runtime 0.76-9         Runtime support for the PAM library
ii  libpam0g       0.76-9         Pluggable Authentication Modules library
ii  libparted1.6-0 1.6.5-1        The GNU Parted disk partitioning shared libr
ii  libpcap0       0.6.2-2        System interface for user-level packet captu
ii  libperl5.6     5.6.1-7        Shared Perl library.
ii  libpopt0       1.6.4-2        lib for parsing cmdline parameters
ii  libreadline4   4.3-5          GNU readline and history libraries, run-time
ii  libsasl7       1.5.27-3.3     Authentication abstraction library.
ii  libsqlite0     2.4.7-1        SQLite shared library
ii  libssl0.9.6    0.9.6g-6       SSL shared libraries
ii  libstdc++2.10  2.95.2-14      The GNU stdc++ library
ii  libstdc++2.10- 2.95.4-15      The GNU stdc++ library
ii  libusb-0.1-4   0.1.6a-2.1     Userspace USB programming library
ii  libwrap0       7.6-ipv6.1-3   Wietse Venema's TCP wrappers library
ii  lilo           22.5.6.1-1     LInux LOader - The Classic OS loader can loa
ii  login          4.0.3-7        System login tools
ii  loop-aes       1.6i-1         AES (Advanced Encryption Standard) Kernel mo
rc  lpr            2000.05.07-4.2 BSD lpr/lpd line printer spooling system
ii  lprng          3.8.10-1.2     lpr/lpd printer spooling system
ii  makedev        2.3.1-62       Creates device files in /dev.
ii  mawk           1.3.3-9        a pattern scanning and text processing langu
ii  mkisofs        1.10-7         Creates ISO-9660 CD-ROM filesystem images.
ii  modutils       2.4.21-1       Linux module utilities.
ii  mount          2.11y-1        Tools for mounting and manipulating filesyst
ii  mountapp       3.0-2.1        Tool to (un)mount devices, dockable in Windo
ii  mouseconfig    0.5-2          Lightweight mouse configuration tool for Kno
ii  mpg321         0.2.10.1       A Free command-line mp3 player, compatible w
ii  nano-tiny      1.0.6-2        free Pico clone with some new features - tin
ii  ncurses-base   5.3.20021109-2 Descriptions of common terminal types
ii  ncurses-bin    5.3.20021109-2 Terminal-related programs and man pages
ii  net-tools      1.60-4         The NET-3 networking toolkit
ii  netbase        4.09           Basic TCP/IP networking system
ii  netcardconfig- 0.5-14         Minimalistic ncurses/dialog-based network co
ii  netkit-inetd   0.10-9         The Internet Superserver
ii  nfs-common     1.0-2          NFS support files common to client and serve
ii  nvi            1.79-20        4.4BSD re-implementation of vi.
ii  parted         1.6.5-1        The GNU Parted disk partition resizing progr
ii  passwd         4.0.3-7        Change and administer password and group dat
ii  perl-base      5.8.0-15       The Pathologically Eclectic Rubbish Lister.
ii  portmap        5-2            The RPC portmapper
ii  ppp            2.4.1.uus-4    Point-to-Point Protocol (PPP) daemon.
ii  ppp-scripts-kn 0.5-1          PPP connection scripts for various providers
ii  pppconfig      2.1            A text menu based utility for configuring pp
ii  procps         3.1.5-1        The /proc file system utilities
ii  psmisc         21.2-1         Utilities that use the proc filesystem
ii  pump           0.8.11-8       Simple DHCP/BOOTP client.
ii  rebuildfstab-k 0.5-4          fstab-rebuilder for KNOPPIX
ii  scanpartitions 0.5-4          fstab-helper for KNOPPIX
ii  sed            3.02-8.1       The GNU sed stream editor
ii  slang1         1.4.4-7.2      The S-Lang programming library - runtime ver
ii  sqlite         2.4.7-1        A command line interface for SQLite
ii  sudo           1.6.7p3-2      Provide limited super user privileges to spe
ii  syslinux       2.00-2         Bootloader for Linux/i386 using MS-DOS flopp
ii  sysvinit       2.84-143       System-V like init with KNOPPIX scripts.
hc  sysvinit-knopp 2.84-1         System-V like init with KNOPPIX scripts.
ii  tar            1.13.25-5      GNU tar
ii  tcc            0.9.18-3       The smallest ANSI C compiler
ii  tcpd           7.6-ipv6.1-3   Wietse Venema's TCP wrapper utilities
ii  traceroute     1.4a12-12      Traces the route taken by packets over a TCP
ii  usbutils       0.9-1          USB console utilities
ii  usleep-knoppix 0.5-1          sleeps for a number of microseconds, see man
ii  util-linux     2.11y-1        Miscellaneous system utilities.
ii  wireless-tools 26-1           Tools for manipulating Linux Wireless Extens
ii  wlcardconfig-k 0.5-2          Minimalistic ncurses/dialog-based WLAN confi
ii  zlib1g         1.1.4-6        compression library - runtime
