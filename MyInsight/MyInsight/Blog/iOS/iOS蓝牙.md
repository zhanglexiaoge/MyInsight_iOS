#  iOS 蓝牙


### 中心模式的流程
1. 建立中心角色
2. 扫描外设
3. 发现外设
4. 连接外设
5. 扫描外设中的服务
6. 扫描外设对应服务的特征
7. 订阅特征

### 外设模式的流程
1. 建立外设角色
2. 设立本地外设的服务和特征
3. 发布外设和特征
4. 广播服务
5. 响应中心的读写请求
6. 发送更新的特征值，订阅中心



蓝牙4.0开发步骤

```
// 导入头文件
#import  <CoreBluetooth/CoreBluetooth.h>

// 中心管理者
@property (nonatomic, strong) CBCentralManager *manager;
// 外设
@property (nonatomic, strong) CBPeripheral *peripheral;
// 特征写
@property (nonatomic, strong) CBCharacteristic *characteristicWrite;
// 特征读
@property (nonatomic, strong) CBCharacteristic *characteristicRead;
```














### 参考:
[基于MultipeerConnectivity Framework的文件传输](https://www.jianshu.com/p/181ed32b9e92)
[iOS开发拓展篇—蓝牙之GameKit使用](https://www.cnblogs.com/zengshuilin/p/5780712.html)
[iOS开发系列--通讯录、蓝牙、内购、GameCenter、iCloud、Passbook系统服务开发汇总](https://www.cnblogs.com/kenshincui/p/4220402.html#bluetooth)

[<iOS开发>之蓝牙使用](https://www.jianshu.com/p/b62081c427a4)

