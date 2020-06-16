# Linux Deploy CLI for Termux

Termux 下的 Linux Deploy ( 需要root )

### 安装

```shell script
pkg intall -y git
git clone https://github.com/nekohasekai/ld-termux ~/ldt
alias=$(echo alias ldt="~/ldt/ldt.sh")
echo -e "\n$alias" >> ~/.bashrc
source ~/.bashrc
```

### 使用

```
ldt 配置名称 [参数] 命令 ...

已加入部署时缓存, 避免一个包下载失败就得重来. ( debian / fedora 系, arch. )

源脚本参数:
   -d - 调试模式
   -t - 跟踪模式

配置文件目录在 config 下, 已预定义一组 ( aarch64 ):
  - alpine
  - arch
  - debian
  - fedora
  - kali
  - ubuntu

命令:
   login - 直接进入命令行, 退出后将停止容器.

注: 
  挂载后的目录仅当前进程可见, 除非你在 adb 或 ssh for magisk 中运行 (这样可能会无法卸载.)
  无法卸载容器, shell卡住: 强行停止 termux.
  挂载中系统卡死: 在 adb 或 ssh for magisk 中运行.

开机启动?
  使用 magisk service.d 脚本

源脚本命令:
   deploy [...] [PARAMETERS] [-n NAME] [NAME ...] - 安装发行版和指定包
      -m - 挂载
      -i - 不配置
      -c - 不安装
      -n NAME - 跳过指定包
   import FILE|URL - 导入根文件系统档案
   export FILE - 导出根文件系统档案
   shell [-u USER] [COMMAND] - 执行命令, 默认使用 /bin/bash
      -u USER - 用户
   mount - 挂载容器
   umount - 卸载容器
   start [-m] [NAME ...] - 启动容器
      -m - 挂载
   stop [-u] [NAME ...] - 停止容器
      -u - 卸载
   status [NAME ...] - 打印容器状态

源脚本参数:
   --distrib="debian"
     将安装的发行版. 支持 "debian", "ubuntu", "kali", "fedora", "centos", "archlinux", "slackware", "apline".

   --target-type="directory"
     安装类型, 可为 "file", "directory", "partition", "ram" or "custom".

   --target-path="/data/ldt/debian"
     安装目或文件.

   --disk-size="2000"
     安装到文件时的镜像大小. 0 = 自动.

   --fs-type="ext4"
     安装到文件时的镜像文件系统. 支持 "ext2", "ext3" or "ext4"

   --arch="i386"
     处理器架构, 支持 "armel", "armhf", "arm64", "i386" and "amd64".

   --suite="buster"
     发行版版本

   --source-path="http://ftp.debian.org/debian/"
     安装源.

   --extra-packages=""
     附加包.

   --chroot-dir="/mnt"
     挂载文件夹.

   --emulator="qemu-i386-static"
     模拟器 (自行安装).

   --mounts="/sdcard /data /stotage:/mnt"
     挂载文件夹.

   --dns="auto"
     DNS 服务器, auto 或者多个IP地址.

   --net-trigger=""
     容器内的用于接收网络环境变化的脚本 (仅 Linux Deploy App 内有效).

   --locale="C"
     语言, 例如: "zh_CN.UTF-8".

   --user-name="root"
     用户名.

   --user-password="114514"
     用户密码.

   --privileged-users="android:aid_inet android:aid_media_rw"
     特权用户.

```
