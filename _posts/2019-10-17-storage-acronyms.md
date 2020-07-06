---
layout: post
title: "Brief Summary of I/O Interface and Some Related Acronyms"
date: 2019-10-17 20:07:37
author: Guanzhou Hu
categories: Technical
---

学习存储系统的过程中不可避免地会接触到许多硬件层面的术语简称，包括硬件设备、接口、传输和控制协议等。在打超算比赛时想起，应该把这些整理成文以做总结。原写于 3 月，10 月再次修改如下。图片地址仍然在原 CNBlogs 站上没有迁移，等哪天链接崩了再换成更新的图吧。

## 常见硬盘设备简称

### 0. Tape、CD-ROM

Tape（磁带）、CD-ROM（只读光盘）等设备早已不再作为现代计算机的永久存储设备了，故此文略过。

### 1. HDD

**HDD**（*Hard Disk Drive*，*硬盘*）是以旋转的磁片和运动的磁头组成的永久存储设备，最广为使用且单位价格非常低廉，但机械结构较易受外力损坏。顺序读写性能较好，但大量的随机跳跃读写就会导致严重的性能下降。[^13]

HDD 自早期发展以来有如下这些主流数据接口模式：IDE（ATA / PATA）、SATA、SCSI、SAS、FC 等。接口类型会在下一部分详述。

典型 HDD 硬盘如图：

<img src="https://img-blog.csdnimg.cn/20190321170447313.jpg" />

### 2. SSD

**SSD**（*Solid-State Drive*，*固态硬盘*）是一种基于闪存（Flash Memory）的永久存储设备，它没有传统磁盘的复杂机械结构，取而代之的是由闪存组成的电子存储块，在性能上有不小的进步；价格也稍贵。固态盘在顺序与随机读写上性能差异不大，尤其数据读取都是非常迅速的，但一大缺陷是数据的写入必须以较大的 Block 为单位来实现，故而在高频的随机小量写入上会在 Garbage Collection 阶段引入巨量的 overhead，使得性能甚至不如磁盘。同时高强度的工作场景下 SSD 的寿命也会损耗很快。[^14]

SSD 广泛采用 SATA（SATA III，及后来小型化的 mSATA 即 mini SATA）接口，许多新款 SSD 都采用较昂贵的 PCIe 接口，而追求极致小型化的 M.2 接口也开始走进 SSD 设备领域。

典型 SSD 固态盘如图：

<img src="https://img-blog.csdnimg.cn/20190321163540953.jpg" />

> 一些有关 **NVM**（*Non-Volatile Memory*，*非易失性存储器*）的梳理：
> 1. 理论上所有永久存储器（Persistent Memory）都是非易失性存储器，即断电仍可保留数据的存储设备；但一般提及 Non-Volatile 一词时，一般指没有 HDD 机械结构的电子非易失存储器， 主要包括两类：
>     - **ROM**（*Read-Only Memory*，*只读内存*），性能很好但通常只读（擦除重写代价高）、容量小、单位成本很高，现代计算机中一般仅用于放置固件。
>     - **Flash Memory**（*闪存*），来源于特殊的可擦除式 ROM，后发展成为独立的一类可多次擦写、性能较好的永久存储器。闪存的一大缺陷是数据的写入必须以较大的 Block 为单位来实现，存在读写性能的断裂问题。固态硬盘 SSD 即是基于 Flash 发展而来的。
> 2. ROM v.s. RAM：
>     - ROM 是非易失的，但通常只读，因为难以擦除重写数据。**EEPROM**（*Electrically-Erasable Programmable Read-Only Memory*，*电可擦除可编程只读存储器*）是一种可用特定电压擦除重写的 ROM，被广泛用于 BIOS。基于 EEPROM 发展出了闪存技术。
>     - **RAM**（*Random-Access Memory*，*随机存取存储器*）是一类必须依靠持续供电才能保留数据的存储设备，故是易失的（Volatile）。它构成了现代计算机中所谓的 Memory（主存，内存），速度很快，为计算单元提供临时存储介质，也为二级存储提供了缓存；相应的，RAM 断电就会失去数据。RAM 分如下两类：
>         - **SRAM**（*Static RAM*，*静态随机存取存储器*）是速度最快的一类 RAM，但成本昂贵，常用于制造各类缓存。
>         - **DRAM**（*Dynamic RAM*，*动态随机存取存储器*）性能稍逊但单位成本更低，被大量采用为现代系统中的内存。[^15]

### 3. HHD

**HHD**（*Hybrid Drive*，*Solid State Hybrid Drive*，*混合硬盘*，*SSHD*）是在传统机械硬盘的基础上，加入了固态硬盘的闪存颗粒以做缓存而构成的混合硬盘。虽然混合盘在机械硬盘和固态硬盘之间做了 Tradeoff，但实际应用中往往不如 小容量固态 + 大容量机械盘 的双硬盘组合来的方便有效，故不被广泛采用。[^16]

## 常见接口类型简称

### 0. ESDI

**ESDI**（*Enhanced Small Disk Interface*，*增强小型磁盘接口*）是 80 年代早期设计的磁盘接口，当时 IDE 接口系列和 SCSI 接口系列仍在雏形阶段，ESDI 是主要的磁盘设备接口。在 90 年代左右就已被后续的接口标准取代。[^0]

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321150433533.jpg" />

### 1. IDE / ATA / PATA

**IDE**（*Integrated Drive Electronics*，*集成驱动电子设备*）指一种把驱动器和存储盘体集成在一起的硬盘技术，早期的 PC 主要兼容采纳 IDE 技术的硬盘。现在人们也混用 IDE 一词指代此类硬盘所对应的控制器接口，但其相匹配的控制器技术及总线接口实际应叫做 **ATA**（*Advanced Technology Attachment*，*高技术配置*）。ATA 接口是一种并行通信接口，由于后续 SATA（Serial ATA）串行接口的流行，传统 ATA 接口也与之相对的被称作 **PATA**（*Parellel ATA*，*并行 ATA*），已逐渐被淘汰不再使用。目前 IDE、ATA、PATA 三种简称常被混用，中文普遍称作 “并口”。[^1] [^2] [^3]

典型 ATA 排线接口及对应主板插槽如下图：

排线接口：

<img src="https://img-blog.csdnimg.cn/20190321125509792.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/20190321125638803.jpg" />

### 2. SATA

**SATA**（*Serial ATA*，*串行 ATA*）是由传统 ATA 接口进化而来的串行总线接口，于 2000 年由各大硬盘厂商组成的 “Serial ATA Working Group” 正式制定推出。由于串口的各种优势，其逐渐取代了旧式 PATA 口，成为最被广泛采用的硬盘 I/O 接口。如今 SATA 接口已经发展出 SATA I、SATA II、SATA III 代以及 eSATA，mSATA（mini SATA）和 SATA Express 等版本。[^3] [^4]

典型 SATA 排线接口及对应主板插槽如下图，接口宽侧为供电口，主板示例图中没有供电口：

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321133803869.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/20190321131842651.jpg" />

> 通信接口中，串行通常比并行更快、性能更好，因为大量密集并行的通信线之间干扰严重，使得并口的时钟频率必须维持较低水平才能保持稳定；而串口则没有这一问题，时钟频率可以设计得很快，同时还保持着相当的稳定性，以及占用机箱空间少、不阻碍和影响散热、支持热插拔等多种优点。因此现代 I/O 通信接口往往是串行通信的。

### 3. SCSI

**SCSI**（*Small Computer System Interface*，*小型计算机系统接口*）是一种针对小型计算机系统设计的、用于计算机与各类周边设备之间通信的接口，相对上述 IDE 发源的接口是完全独立的一类。它由美国国家标准协会（ANSI）设计，并非是专门针对存储设备，但最为广泛的应用还是在存储设备上。它是一种高速数据传输技术，相比 IDE 系列接口有带宽大、CPU 占用低等优点，但价格也相对昂贵。[^6]

典型 SCSI 排线接口及对应主板插槽如下图：

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321133306258.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/20190321133324960.jpg" />

### 4. SAS

**SAS**（*Serial Attached SCSI*，*串列 SCSI*）是由 SCSI 接口发展而来的串行接口。其接口设计有多种形式，其中 8482 标准类型可以与 SATA 硬盘向下兼容，即 SATA 硬盘可以接在 SAS 口主板上使用，反之不行。SAS 接口的理论性能和稳定性较 SATA 更优，但普及程度仍不及 SATA，价格也相对更贵，还在发展阶段。[^3] [^5]

标准 SAS 接口与 SATA 硬盘兼容，故非常相似，只略有细微不同：

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321141504888.jpg" />

### 5. FC、IB

**FC**（*Fibre Channel*，*光纤通道*）原是适用于高速网络互联的通信技术，后逐渐成为高性能超级计算和企业级存储设备中常用的高性能 I/O 通信连接类型。近年来在高性能存储中已逐步被性能更极致的 IB（InfiniBand）互联所取代。[^7] **IB**（*InfiniBand*）同样也是用于高速网络互联的新兴技术。在 Ethernet（以太网）早已不能满足高性能计算中的网络通信的时代，FC 被应用于高性能存储的连接；近年来 IB 以其优于 FC 的极致的性能被广泛使用。随着大规模集中共享存储节点的流行，IB 在高性能存储中也扮演起愈发重要的角色。[^8]

典型 FC 线接口及对应主板插槽如下图：

FC 线：

<img src="https://img-blog.csdnimg.cn/20190321140929682.jpg" />

主板插槽口：

<img src="https://img-blog.csdnimg.cn/20190321140951469.png" />

典型 IB 线接口及对应交换机插槽如下图：

IB 线：

<img src="https://img-blog.csdnimg.cn/20190321142825476.jpg" />

交换机插槽：

<img src="https://img-blog.csdnimg.cn/20190321142847663.png" />

### 6. PCIe

PCI（*Pheripheral Component Interconnect*，*外设元件互联标准*，*Personal Computer Interface*， *个人计算机接口*）是一种广为使用的计算机总线标准，是早期的标准扩展总线，标准涵盖了网卡、声卡、显卡等，亦包括部分硬盘。然而受 PCI 的传输性能局限，其早已无法满足现代的显卡和存储设备的要求，而后续出现的 PCIe 接口解决了这一问题。**PCIe**（*PCI Express*）是沿用了 PCI 总线的标准而建立的更快的串行通信接口，主要由 Intel 提供开发支持。它的出现使得新款的计算机设备的系统总线几乎全部统一采用了 PCIe 标准。PCIe 接口带来了强大的通用性，不仅支持各种外设连接，也广泛应用于 SSD 和高性能显卡的接口。后也出现了小型化的 PCI Express Mini。[^9] [^10]

典型 PCIe 接口及对应主板插槽（不同规格）如下图：

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321145800177.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/2019032114582726.jpg" />

### 7. M.2

**M.2**（前身 *NGFF*，*Next Generation Form Factor*），是由 Intel 主导的追求适配小型化超极本的存储接口设计，出现后逐步替代了个人机小型 SSD 曾广泛使用的 mSATA 和 PCIe Mini 接口而成为个人机主流 SSD 接口。M.2 接口的逻辑设计同时支持了 AHCI 和 NVMe 控制协议标准，对两者的主板支持则常分别称为 SATA 通道 和 PCIe 通道。[^17]

典型 M.2 接口及主板插槽如下图：

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321230411987.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/20190321230451494.jpg" />

### (extra.) DDR

另一个常见的主板接口名字是 **DDR**，它代表了 DDR SDRAM（*Double Data Rate Synchronous Dynamic Random Access Memory*，*双倍数据率同步动态随机存取存储器*），是同步 DRAM 的进化版本，现也常被用于称呼主板内存条接口。DDR 目前已经更新到了 DDR-4 版本。

接口样式：

<img src="https://img-blog.csdnimg.cn/20190321180209363.jpg" />

主板插槽：

<img src="https://img-blog.csdnimg.cn/20190321180404571.jpg" />

由于其不属于 persistent storage I/O 接口，故未放在本文列表内。

> USB 相关的各 Type- 支持移动硬盘的接口，及 eSATA 接口，暂不列在此文内，参见 [Wikipedia/USB](https://en.wikipedia.org/wiki/USB)。

## 常见控制协议简称

### 1. AHCI

**AHCI**（*Advanced Host Controller Interface*，高级主机控制器接口）是由 Intel 指定的一系列主板控制器技术标准，它规定了主板系统存储控制器与 SATA 存储设备之间的通信协议（Protocal）和厂商应该实现的硬件标准。大部分 AHCI 控制器都向后兼容 PATA 运行模式，并可同时开启 RAID 功能。逻辑层面，M.2 接口的设计遵循 AHCI 协议（称 SATA 通道），但同时也支持 NVMe。[^11]

### 2. NVMe

**NVMe**（*Non-Volatile Memory Host Controller Interface Specification*，*非易失性内存主机控制器接口规范*，*NVM Express*）是近年出现的专门针对非机械式非易失性内存存储器的控制器规范标准。由于近年来最为主要的非易失性存储就是基于闪存的 SSD，而大部分新款 SSD 都采用 PCIe 接口，故 NVMe 控制协议也常被简单视作为是专为控制 PCIe 接口设备而必须使用的协议；但理论上不止于此。逻辑层面，M.2 接口的设计遵循 AHCI 协议，但同时也支持 NVMe（称 PCIe 通道）。[^12]

## References

[^0]: https://en.wikipedia.org/wiki/Enhanced_Small_Disk_Interface
[^1]: https://www.webopedia.com/TERM/I/IDE_interface.html
[^2]: https://en.wikipedia.org/wiki/Parallel_ATA
[^3]: https://blog.csdn.net/tianlesoftware/article/details/6009110
[^4]: https://en.wikipedia.org/wiki/Serial_ATA
[^5]: https://en.wikipedia.org/wiki/Serial_Attached_SCSI
[^6]: https://en.wikipedia.org/wiki/SCSI
[^7]: https://en.wikipedia.org/wiki/Fibre_Channel
[^8]: https://en.wikipedia.org/wiki/InfiniBand
[^9]: https://en.wikipedia.org/wiki/PCI_Express
[^10]: https://en.wikipedia.org/wiki/Conventional_PCI
[^11]: https://en.wikipedia.org/wiki/Advanced_Host_Controller_Interface
[^12]: https://en.wikipedia.org/wiki/NVM_Express
[^13]: https://en.wikipedia.org/wiki/Hard_disk_drive
[^14]: https://en.wikipedia.org/wiki/Solid-state_drive
[^15]: https://en.wikipedia.org/wiki/Random-access_memory
[^16]: https://en.wikipedia.org/wiki/Hybrid_drive
[^17]: https://en.wikipedia.org/wiki/M.2