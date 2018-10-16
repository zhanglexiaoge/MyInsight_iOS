//
//  BabyBleVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/28.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "BabyBleVC.h"
#import "BluetoothCell.h"
#import "BabyBluetooth.h"
#import "Header.h"
#import "BlueToothDataVC.h"

@interface BabyBleVC ()

@property (nonatomic, strong) BabyBluetooth *babyBluetooth;
// 蓝牙设备
@property (nonatomic, strong) CBPeripheral *peripheral;
// 蓝牙特征写
@property (nonatomic, strong) CBCharacteristic *characteristicWrite;
// 蓝牙特征读
@property (nonatomic, strong) CBCharacteristic *characteristicRead;

// 蓝牙设备可变数组
@property (nonatomic, strong) NSMutableArray *bluetoothArray;

@end

@implementation BabyBleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙(三方)";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化可变数组
    self.bluetoothArray = [[NSMutableArray alloc] init];
    // 设置蓝牙
    [self setupBluetooth];
    // 设置列表
    [self setupTableView];
}

- (void)setupBluetooth {
    self.babyBluetooth = [BabyBluetooth shareBabyBluetooth]; // 初始化
    NSArray *bleArray = [[BabyBluetooth shareBabyBluetooth] findConnectedPeripherals];

    self.babyBluetooth.scanForPeripherals().begin();
    
    // 设置block
    [self setupBabyBluetoothDelegate];
    // 设置蓝牙委托
    
    if (bleArray.count != 0) {
        // 此时蓝牙连接设备
    } else {
        // 设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态，扫描设备
        [_babyBluetooth.centralManager scanForPeripheralsWithServices:NULL options:NULL];
        
    }
}

/*************************************** 蓝牙协议实现方法 ********************************/
#pragma mark - 设置蓝牙协议哦
-(void)setupBabyBluetoothDelegate {
    // 设置扫描到设备的委托
    __weak typeof(self) weakSelf = self;
    // 发现设备
    [self.babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        // 初始化数组
        if (weakSelf.bluetoothArray == NULL) {
            weakSelf.bluetoothArray = [[NSMutableArray alloc] init];
        }

        // 设置数组
        NSArray *peripheralArray = [weakSelf.bluetoothArray valueForKey:@"peripheral"];

        // 从UUID判断新设备是否已存在
        BOOL hasExist = NO;
        for (int i = 0; i < peripheralArray.count; i++) {
            CBPeripheral *p = peripheralArray[i];
            NSString *UUID = [p.identifier UUIDString];
            if ([[peripheral.identifier UUIDString] isEqualToString:UUID]) {
                hasExist = YES;
                break;
            }
        }
        
        // 添加蓝牙到数组
        if (!hasExist) {
            // 添加到tableView最后一行
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.bluetoothArray.count inSection:0];
            [indexPaths addObject:indexPath];

            // 设置字典
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            [item setValue:peripheral forKey:@"peripheral"];
            [item setValue:RSSI forKey:@"RSSI"];
            [item setValue:advertisementData forKey:@"advertisementData"];
            [weakSelf.bluetoothArray addObject:item];
            // 更新列表数据
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    // 蓝牙连接成功 扫描服务
    [self.babyBluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"蓝牙连接成功");
        // 发现服务
        [peripheral discoverServices:@[[CBUUID UUIDWithString:Data_Service]]];
    }];
    // 设置连接失败 接Peripherals失败的委托
    [self.babyBluetooth setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败", peripheral.name);
    }];
    // 断开连接
    [self.babyBluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"====断开连接");
    }];
    // 获取服务 设置查找服务回叫
    [self.babyBluetooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        // 遍历服务
        for (CBService *service in peripheral.services) {
            if ([service.UUID.UUIDString isEqual:Data_Service]) {
                // 设备发现特征
                [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:Data_Character_Write], [CBUUID UUIDWithString:Data_Character_Read]] forService:service];
            }
        }
    }];
    // 4.扫描特征 与蓝牙数据交互
    [self.babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        // 遍历特征咯
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqual:Data_Character_Read]) {
                NSLog(@"扫描完服务 扫描特征 特征==FFF2 读出 通知");
                // 将特征赋值给读出特征
                weakSelf.characteristicRead = characteristic;
                // 订阅通知 FFF2
                [weakSelf.peripheral setNotifyValue:YES forCharacteristic:weakSelf.characteristicRead];
            }
            
            if ([characteristic.UUID.UUIDString isEqual:Data_Character_Write]) {
                NSLog(@"扫描完服务 扫描特征 特征=FFF1 写入 ");
                // 赋值
                weakSelf.characteristicWrite = characteristic;
                weakSelf.peripheral = peripheral;
                
                NSLog(@"写入特征 %@", weakSelf.characteristicWrite);
                // 写入密码
            }
        }
    }];
    // 5.订阅更新 接收指令
    [self.babyBluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (characteristic.value == NULL) {
            // 自动连接 重新连接～～
            [weakSelf.peripheral autoContentAccessingProxy];
            return;
        }
        
        
    }];
}

#pragma mark 设置TableView
- (void)setupTableView {
    // footerview 去除多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 分割线颜色
    self.tableView.separatorColor = [UIColor clearColor];
    // 适配iOS11 [你可能需要为你的APP适配iOS11](https://www.jianshu.com/p/370d82ba3939)
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BluetoothCell" bundle:nil]
         forCellReuseIdentifier:@"BluetoothCell"];
}

#pragma mark - 实现tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bluetoothArray.count;
}

// 生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BluetoothCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BluetoothCell" owner:self options:nil]lastObject];
    }
    // 取消cell的选中手势
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *item = [_bluetoothArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSString *peripheralName;
    if (peripheral.name.length > 0) {
        peripheralName = peripheral.name;
    } else {
        peripheralName = @"No name";
    }
    // Label显示名字
    cell.bleNameLabel.text = peripheralName;
    // 信号值
    cell.rssiLabel.text = [NSString stringWithFormat:@"RSSI:%@", [item objectForKey:@"RSSI"]];
    // 设备的标识符
    cell.identifierLabel.text = [NSString stringWithFormat:@"%@", peripheral.identifier];
    // 广播数据
    NSDictionary *dict = [item objectForKey:@"advertisementData"];
    // 设备的广播中的服务uuid
    cell.serviceUUIDLabel.text = [NSString stringWithFormat:@"Service UUID:%@", [dict objectForKey:@"kCBAdvDataServiceUUIDs"][0]];
    // 广播传播的数据
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BlueToothDataVC *blueToothDataVC = [[BlueToothDataVC alloc] init];
    blueToothDataVC.hidesBottomBarWhenPushed = YES;
    NSDictionary *item = [self.bluetoothArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    // 下一页面的蓝牙设备
    blueToothDataVC.peripheral = peripheral;
    
    [self.navigationController pushViewController:blueToothDataVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
