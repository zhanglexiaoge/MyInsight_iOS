//
//  BlueToothVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/25.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "BlueToothVC.h"
#import "BluetoothCell.h"
#import  <CoreBluetooth/CoreBluetooth.h>
#import "BlueToothDataVC.h"

@interface BlueToothVC ()<CBCentralManagerDelegate, CBPeripheralDelegate>
// 中心管理者
@property (nonatomic, strong) CBCentralManager *manager;
// 外设
@property (nonatomic, strong) CBPeripheral *peripheral;
// 特征写
@property (nonatomic, strong) CBCharacteristic *characteristicWrite;
// 特征读
@property (nonatomic, strong) CBCharacteristic *characteristicRead;
// 蓝牙可变数组
@property (nonatomic, strong) NSMutableArray *bluetoothArray;

@end

@implementation BlueToothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙(系统)";
    // 蓝牙页面
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化数组
    self.bluetoothArray = [[NSMutableArray alloc] init];
    // 设置蓝牙
    [self setupBlueTooth];
    // 创建TableView
    [self creatTableView];
}

// 创建TableView
- (void)creatTableView {
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

// 设置蓝牙
- (void)setupBlueTooth {
    // 创建管理者
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark 设置蓝牙
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"更新中心管理状态");
    if (central.state == CBCentralManagerStatePoweredOff) {
        NSLog(@"蓝牙关闭, 弹出打开蓝牙提示");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙关闭，打开蓝牙？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定打开蓝牙");
            // 打开设置页面
            if ([UIDevice currentDevice].systemVersion.doubleValue <= 10) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=General&path=Bluetooth"]];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消打开蓝牙");
        }];
        
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
    
    // 扫描蓝牙设备
    [self.manager scanForPeripheralsWithServices:NULL options:NULL];
}

// 扫描发现蓝牙设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 初始化数组
    if (self.bluetoothArray == NULL) {
        self.bluetoothArray = [[NSMutableArray alloc] init];
    }
    
    // 设置数组
    NSArray *peripheralArray = [self.bluetoothArray valueForKey:@"peripheral"];
    
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.bluetoothArray.count inSection:0];
        [indexPaths addObject:indexPath];
        
        // 设置字典
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [self.bluetoothArray addObject:item];
        // 更新列表数据
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// 查询蓝牙服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
}

#pragma mark UITableView的代理实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bluetoothArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BluetoothCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BluetoothCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *item = [self.bluetoothArray objectAtIndex:indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
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
