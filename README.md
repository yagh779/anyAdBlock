本项目通过 [Magisk](https://github.com/topjohnwu/Magisk) 、[KernelSU](https://github.com/tiann/KernelSU) 或 [APatch](https://github.com/bmax121/APatch) 部署 AdGuardHome、mosdns 进行dns层面的广告过滤，防止dns劫持。

## 免责声明

本项目不对以下情况负责：设备变砖、SD 卡损坏或 SoC 烧毁。

**请确保您的配置文件不会造成流量回环，否则可能会导致您的手机无限重启。**

如果你真的不知道如何配置这个模块，你可能需要像 AdGuard 等应用程序。


## 安装

- 从 [Release](https://github.com/yagh779/anyAdBlock/releases) 页下载模块压缩包，然后通过 Magisk Manager，KernelSU Manager 或 APatch 安装
- 支持后续在 Magisk Manager 中在线更新模块（更新后免重启即生效）
- 更新模块时会备份用户配置，且附加用户配置至新 `/data/adb/aab/scripts/aab.config` 文件（在 shell 中，后定义的变量值会覆盖之前的定义值，但仍建议更新模块后再次编辑 `aab.config` 文件去除重复定义与移除废弃字段）

### 注意

模块开箱即用，相应核心文件位于 `/data/adb/aab/bin/` 目录下。

模块默认运行AdGuardHome，默认携带的mosdns为mosdns-x。
  
模块安装完成后也可以自行更改不同版本核心，文件放置到 `/data/adb/aab/bin/` 目录下即可。


## 配置

- 各核心工作在 `/data/adb/aab/核心名字` 目录，核心名字由 `/data/adb/aab/scripts/aab.config` 文件中 `bin_name` 定义，有效值只有 `AdGuardHome`、`mosdns` **决定模块启用的核心**
- 各核心配置文件需用户自定义，模块脚本会检查配置合法性，检查结果存储在 `/data/adb/aab/run/check.log` 文件中
- 提示：`AdGuardHome` 和 `mosdns` 核心自带默认配置已做好脚本工作的准备，进阶配置请参考相应官方文档。地址：[AdGuardHome 文档](https://github.com/AdguardTeam/AdGuardHome/wiki)，[mosdns-x 文档](https://github.com/pmkol/mosdns-x/wiki)

## 使用方法

### 常规方法（默认 & 推荐方法）

#### 管理服务的启停

**以下核心服务统称 aab**

- aab 服务默认会在系统启动后自动运行
- 您可以通过 Magisk Manager 应用打开或关闭模块**实时**启动或停止 aab 服务，**不需要重启您的设备**。启动服务可能需要等待几秒钟，停止服务可能会立即生效
- aab 默认接管所有安卓用户的所有应用程序（APP）

### 高级用法

#### 更改启动 aab 服务的用户

- aab 默认使用 `root:net_admin` 用户用户组启动

- 打开 `/data/adb/aab/scripts/aab.config` 文件，修改 `aab_user_group` 的值为设备中已存在的 `UID:GID`，此时 aab 使用的核心必须在 `/system/bin/` 目录中（可以使用 Magisk），且需要 `setcap` 二进制可执行文件，它被包含在 [libcap](https://android.googlesource.com/platform/external/libcap/) 中

##### 管理服务的启停

- aab 服务脚本是 `/data/adb/aab/scripts/aab.service`

- 例如，在测试环境中（Magisk version: 25200）

  - 启动服务：

    `/data/adb/aab/scripts/aab.service start`

  - 停止服务：

    `/data/adb/aab/scripts/aab.service stop`

  - 重启服务：

    `/data/adb/aab/scripts/aab.service restart`

  - 显示状态：

    `/data/adb/aab/scripts/aab.service status`
  
##### 管理ip(6)tables是否启用

- ip(6)tables脚本是 `/data/adb/aab/scripts/aab.iptables`

- 例如，在测试环境中（Magisk version: 25200）

  - 启用ip(6)tables：

    `/data/adb/aab/scripts/aab.iptables enable`

  - 停用ip(6)tables：

    `/data/adb/aab/scripts/aab.iptables disable`

  - 重载ip(6)tables：

    `/data/adb/aab/scripts/aab.iptables renew`
  
## 其他说明

- 修改各核心配置文件时请保证相关配置与 `/data/adb/aab/scripts/aab.config` 文件中的定义一致

- aab 服务的日志在 `/data/adb/aab/run` 目录


## 卸载

- 从 Magisk Manager，KernelSU Manager 或 APatch 应用卸载本模块，会删除 `/data/adb/service.d/aab_service.sh` 文件，保留 aab 数据目录 `/data/adb/aab`
- 可使用命令清除 aab 数据：`rm -rf /data/adb/aab`

## 鸣谢

- [AdGuardHomeForRoot](https://github.com/twoone-3/AdGuardHomeForRoot)
- [box4magisk](https://github.com/CHIZI-0618/box4magisk)
