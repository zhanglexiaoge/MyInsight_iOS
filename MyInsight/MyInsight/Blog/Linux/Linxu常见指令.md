##  Linux常见指令

### 网络请求工具 Curl

### 下载工具 Axel

### 下载工具 Wget

### Aria2
aria2是Linux下一个命令行下轻量级，多协议，多来源的高速下载工具。
安装：sudo apt-get install aria2
使用说明：
#简单使用：只需要加上下载链接即可
aria2c ${link}
#分段下载
aria2c -s ${link}

Aria2在百度云环境下可以不限速下载，传送Aria2 - 可能是现在下载百度云资料速度最快的方式。


### CMake



手动防火墙放行端口

```
iptables -I INPUT -p tcp -m tcp --dport 1002 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 1002 -j ACCEPT
iptables-save
```


PS:请把1002换成你需要的端口。

查看服务是否启动成功

搭建SS参考下面教程  
[腾讯云主机搭建ss过程](https://blog.csdn.net/sinat_33479559/article/details/80772004)    

这些没参考
[腾讯云使用ss搭建代理](https://blog.csdn.net/hao931126/article/details/79837779) 
[自己手动搭建SS优雅上网](http://blog.51cto.com/13589319/2125370)  




########################################


## 在 Ubuntu15.10上安装Quartus15.0开发环境

周末在家弄了弄Linux上FPGA的开发环境，嘿嘿嘿，我的黑金开发板又可以没事儿玩玩了～

之前在Altera官网下载软件，一直下载不了，返回错误是认证错误...不知道咋弄，就重新注册了个账号，嘿嘿，就可以下载了。不过在linux上下载，网页上下载东西实在太慢，链接还不稳定，就使用linux命令行下载工具，百度一下，还挺多，简单地权衡了一下，选择使用axel。


axel可以多线程下载，也可以断点续传。安装：

sudo apt-get install axel

axel下载文件的格式如下：

axel -n [线程数] -o [下载到本地地址]  [下载文件的URL]   

axel -n 4 -o /home/sml/下载 http://download.altera.com/akdlm/software/acdsinst/15.0/145/iso/Quartus-web-15.0.0.145.iso

如果官网下载不了，可以使用以下的链接下载；

DVD文件：

http://download.altera.com/akdlm/software/acdsinst/15.0/145/iso/Quartus-web-15.0.0.145.iso 

Help文件：

http://download.altera.com/akdlm/software/acdsinst/15.0/145/ib_installers/QuartusHelpSetup-15.0.0.145-linux.run 

Update（更新）：

http://download.altera.com/akdlm/software/acdsinst/15.0.2/153/update/QuartusSetup-15.0.2.153-linux.run 

http://download.altera.com/akdlm/software/acdsinst/15.0/145/ib_installers/QuartusSetupWeb-15.0.0.145-linux.run 

下载完毕后；把iso解压，解压完后更改整个文件夹的权限；然后准备安装；

好了，首先将系统默认的dash shell修改为bash shell，据说是为了避免出现莫名其妙的错误或者错误。至于dash和bash的区别我也不太清楚，请自行网上查看。

在终端中输入

sudo dpkg-reconfigure dash

出现一个选择界面，选择no。

在终端切到软件解压的文件路径，在终端输入 

./setup.sh

(网上说quartus是针对redhat发布的所以路径与ubuntu有些不同，要修改setup.sh中的第一行为#!/usr/bin/env bash，但是我下载的版本第一行就是这个，所以不用修改)

虽然quartus ii是64位的，但是需要一些32位库的支持，运行setup.sh时会有提示（You must have the 32-bit compatibility libraries installed for the Quartus II installer and software to operate properly.），终端输入sudo apt-get install libxtst6:i386 libxi6:i386 -y 解决

另一种我见到的解决方法是

Install i386 support for Debian amd64:

# dpkg --add-architecture i386

# apt-get update

# apt-get install libc6:i386

# apt-get install libpng12-0:i386

# apt-get install libfreetype6:i386

# apt-get install libsm6:i386

# apt-get install libxrender1:i386

# apt-get install libfontconfig1:i386

# apt-get install libxext6:i386

# apt-get install libxtst6:i386

运行./setup.sh后，接下来的安装过程和Windows环境下安装过程是一样的，具体不详。

软件破解，去网上搜破解文件，很多的。破解方法和在Windows上的差不多。

安装Quartus II 15.0后（Linux版本），破解方法如下：

# 第一步： 把Crack_QII_15.0_Linux.zip里面的libgcl_afcq.so和libsys_cpt.so文件分别解压缩后，替换到安装目录下/altrea/15.0/quartus/linux64里面的同名文件，这样2个so文件里面的加密点就全部被破解了。

#第二步： 把license.dat里的XXXXXXXXXXXX 用你的网卡号替换(在Quartus II 15.0的Tools菜单下选择License Setup，下面就有NIC ID)。

#第三步： 在Quartus II 15.0的Tools菜单下选择License Setup，然后选择License file，最后点击OK。

#注意：license文件存放的路径名称不能包含汉字和空格，空格可以用下划线代替。

#在64位操作系统下，默认情况是安装程序会产生64位的桌面快捷方式（启动器），如果少数客户遇到安装程序没有自动产生桌面快捷方式（启动器），就在桌面手动新建一个（在“命令”里面指向/root/altera/15.0/quartus/bin/的quartus）。

破解文件链接： 链接: http://pan.baidu.com/s/1slDsd7v  密码: krv3

我的安装OK后，试了试，连上开发板能找到开发板，具体烧写文件没来得及尝试。所以我也没担心的usb驱动什么的。

破解后启动程序环境：

在终端中输入/<你自己的路径>/altera/13.1/quartus/bin/quartus也是可以打开的。

当然也可以自己制作一个关联启动程序的图标。

还有一个安装教程是文件下载完后，解压iso文件，然后把下载的其他文件放在解压文件的components路径下，（要保证文件的权限哦）直接运行脚本就ok了，破解过程如下。

安装教程如下链接：

https://github.com/open-design/quartus-linux-install 

好了，我这两天调查的东西大概这么多，希望对大家有所帮助。

一些参照链接：

http://bbs.eeworld.com.cn/thread-475336-1-1.html 

http://www.linuxdiyf.com/linux/17902.html 

http://www.linuxdiyf.com/linux/15012.html 

