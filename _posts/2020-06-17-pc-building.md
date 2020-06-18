---
layout: post
title: "【游戏+工作站】M-ATX 装机记录 2020"
date: 2020-06-17 05:23:17
author: Guanzhou Hu
categories: Personal
---

在美国勉强算是安顿下来了。这个小公寓可能一呆就是 5 年，故干脆狠下心配了一套 2020 年中高配的【游戏+工作站】的 PC，作为自己 5 年学习生涯的小家。在此将自己第一次亲力亲为的装机过程，尽可能详细地记录下来。

### 整体配置情况

先来一张开箱前的全家福：

![Boxes](/assets/img/pc-building-boxes.jpg)

机箱大小为 M-ATX（Micro ATX），因为不需要 Mini-ITX 这么小放在桌上，M-ATX 机箱用作个人游戏配置刚刚够。具体配置列表如下：

| Category | Config | Number |
| :-: | :-- | :-: |
| Case | Cooler Master Q300L M-ATX Dust Filter | x1 |
| Motherboard | MSI Z390M Gaming Edge AC LGA1151 | x1 |
| CPU | Intel i7-9700KF LGA1151 8 cores 4.7GHz | x1 |
| Memory | Corsair 16GB (x2) DDR4 Memory 3000MHz | x2 |
| Graphics | MSI Nvidia GeForce RTX 2070 8GB GDDR6 | x1 |
| CPU Cooler | Dark Rock 4 be quiet! 200W | x1 |
| Storage SSD | Samsung 970 EVO M.2 NVMe V-NAND SSD 500GB | x2 |
| Storage HDD | Western Digital Performance 3.5" HDD 1TB | x1 |
| Power Supply | GameMax Bronze Modular 650W | x1 |

### 安装流程

#### 1. CPU & 散热

取出主板、CPU、散热器：

![Building1.1](/assets/img/pc-building-1.1.jpg)

步骤：

1. 打开 CPU 仓盖，安装 CPU，合盖，取走遮板
2. 按说明，安装散热器底部支架于主板
3. 上散热胶，安装散热器（注意风扇面方向），最后螺丝需交替拧紧，将散热器牢牢固定
4. 安装风扇，风扇电源接至主板 `CPU_FAN1` 口

完成后如图：

![Building1.2](/assets/img/pc-building-1.2.jpg)

#### 2. 内存

取出内存条：

![Building2.1](/assets/img/pc-building-2.1.jpg)

步骤：

1. 两根内存，故插 `A2` + `B2` 槽，注意插紧到底，最后侧边扣需紧扣
2. 注意避免 CPU 散热器与内存条之间的碰撞

完成后如图：

![Building2.2](/assets/img/pc-building-2.2.jpg)

#### 3. 主板入机箱

机箱拆下侧板，平躺：

![Building3.1](/assets/img/pc-building-3.1.jpg)

步骤：

1. 主板放入机箱，对一下螺丝孔位置，然后取出
2. 拧上所需支架螺丝
3. 放入后部 IO 面板保护板
4. 放入主板，顶到位，确保 IO 保护板不松动，拧上并交替拧紧所需公螺丝
5. 按说明，将机箱面板面包线接至主板 `JFP1` 口（可用细胶带稍加捆绑成一体，不易松动）
6. 机箱面板 USB3.0 线接至主板 `USB3` 口
7. 机箱面板 HD Audio 线接至主板 `JAUD1` 口
8. 机箱风扇线接至主板就近的 `SYS_FAN` 口

半完成，尚未插线时如图：

![Building3.2](/assets/img/pc-building-3.2.jpg)

完成后如图：

![Building3.3](/assets/img/pc-building-3.3.jpg)

#### 4. 显卡

取出显卡：

![Building4.1](/assets/img/pc-building-4.1.jpg)

步骤：

1. 取下机箱后部对应槽位的 PCI-E 显卡遮板
2. 将显卡插入 PCI-E 插槽，最后侧边扣需紧扣（注意避免显卡与 USB3.0 线和 JFP 线的卡位）
3. 装回机箱显卡固定板，拧紧螺丝固定

完成后如图：

![Building4.2](/assets/img/pc-building-4.2.jpg)

#### 5. M.2 固态硬盘

> 使用额外大型 CPU 散热器时，这一步可以在安散热前做，避免螺丝难拧。

取出 SSD：

![Building5.1](/assets/img/pc-building-5.1.jpg)

步骤：

1. 取下主板上 M.2 插槽外的垫片螺丝
2. 放入 M.2 盘比对长度，确认固定用的螺丝孔，将垫片螺丝拧上
3. 插入 M.2 SSD 至插槽
4. 拧上公螺丝固定

完成后如图：

![Building5.2](/assets/img/pc-building-5.2.jpg)

#### 6. 电源

> 使用大型独立显卡 + 小型机箱时，这一步可以在安显卡之前做，避免电源无法顺利放入机箱。

取出电源模组：

![Building6.1](/assets/img/pc-building-6.1.jpg)

步骤：

1. 将机箱直立起来
2. 取下机箱后部的电源架，固定在电源模组上拧紧（注意方向）
3. 电源放入机箱，对准后拧上电源架螺丝
4. 供电线全部由就近的走线口，拉到机箱侧部走线区

完成后如图：

![Building6.2](/assets/img/pc-building-6.2.jpg)

供电线都拉到走线区，较为规整：

![Building6.3](/assets/img/pc-building-6.3.jpg)

#### 7. 机械硬盘

取出机械硬盘：

![Building7.1](/assets/img/pc-building-7.1.jpg)

步骤：

1. 取下机箱侧部的机械硬盘架，安装在硬盘上（注意方向）
2. 架子扣回机箱，拧紧螺丝
3. 连接 SATA 线至主板某 `SATA` 口

完成后如图：

![Building7.2](/assets/img/pc-building-7.2.jpg)

#### 8. 供电线安插

所需电源供电线从合适的走线口拉回，在对应部件上插紧：

1. 主板供电 `ATX_PWR`口，插 `20+4pin`
2. CPU 供电 `CPU_PWR` 口，插 `8pin`
3. 显卡 PCI 供电，一个接 `6pin`，一个接 `6+2pin`（PCI 供电线足够时两个都插）
4. 机械硬盘 SATA 供电，接 SATA 供电线
5. 余下不用的供电线，用线绳捆好，整理在走线区

完成后如图：

![Building8](/assets/img/pc-building-8.jpg)

#### 9. 收尾

做如下收尾工作：

1. 拧回机箱盖板
2. 主板 IO 口对应位置拧上 WiFi 天线
3. 吸上机箱防尘遮板
4. 接上主电源线，打开电源开关
5. 接有线以太网线，WiFi 作备用

按机箱电源键测试，成功点亮！

![Building9](/assets/img/pc-building-9.jpg)

接上外设，用安装介质（U 盘）安装系统于固态盘。成功进入系统后，做最后检测：

- 设备管理器中，所有设备均正常检测
- 无线 / 有线网络连接顺畅
- `NovaBench` 跑分正常，温度正常
- 机箱风扇声音正常，无异响
- 在磁盘管理中，添加非系统盘，各自分为一简单卷
- 设备需要驱动 / 管理程序的，安装并保持更新

### Finish XD

正常运行，小家算是搭好了。现在就是非常爽，非常爽.jpg：

![FinishXD](/assets/img/pc-building-finish.jpeg)
