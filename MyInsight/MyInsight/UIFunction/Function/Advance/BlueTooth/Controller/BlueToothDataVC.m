//
//  BlueToothDataVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "BlueToothDataVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"

@interface BlueToothDataVC ()<CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>
// 中心管理者
@property (nonatomic, strong) CBCentralManager *centralManager;
// 特征写
@property (nonatomic, strong) CBCharacteristic *characteristicWrite;
// 特征读
@property (nonatomic, strong) CBCharacteristic *characteristicRead;
// 特征数组
@property (nonatomic, strong) NSMutableArray *characteristicsArray;
// *********************** UI控件 ***************************
// 功能View
@property (nonatomic, strong) UIView *sendDataView;
// 连接状态button
@property (nonatomic, strong) UIButton *connectStateButton;
// 特征写
@property (nonatomic, strong) UIButton *characteristicReadButton;
// 特征读
@property (nonatomic, strong) UIButton *characteristicWriteButton;
// 循环发送时间间隔输入框
@property (nonatomic, strong) UITextField *loopSendTextField;
// 循环发送button
@property (nonatomic, strong) UIButton *loopSendButton;
// 发送数据的列表
@property (nonatomic, strong) UITableView *tableView;
// 接收区
@property (nonatomic, strong) UIView *receiveView;
// 命令+ 最后一行
@property (nonatomic, strong) UIButton *cmdAddButton;
// 命令- 最后一行
@property (nonatomic, strong) UIButton *cmdSubButton;
// 清除button
@property (nonatomic, strong) UIButton *cleanButton;
// 接收区文本
@property (nonatomic, strong) UITextView *receiveTextView;

@end

/*
 [iOS开发之蓝牙通讯](https://my.oschina.net/u/2340880/blog/548127)
 [iOS之蓝牙开发—CoreBluetooth详解](https://www.cnblogs.com/allencelee/p/6707901.html)
 */

@implementation BlueToothDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝牙设备内容";
    // 创建蓝牙中心
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    // 创建UI
    [self creatContentUI];
    // 代码约束布局
    [self masonryLayout];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 断开蓝牙设备
    [self.centralManager cancelPeripheralConnection:self.peripheral];
}

#pragma mark - 创建UI控件
- (void)creatContentUI {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    // 功能View
    self.sendDataView = [[UIView alloc] init];
    [self.view addSubview:self.sendDataView];
    self.view.backgroundColor = [UIColor RandomColor]; // 随机颜色
    // 连接状态
    self.connectStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendDataView addSubview:self.connectStateButton];
    [self.connectStateButton setTitle:@"已连接" forState:UIControlStateNormal];
    self.connectStateButton.backgroundColor = [UIColor RandomColor];
    self.connectStateButton.titleLabel.textColor = [UIColor RandomColor];
    self.connectStateButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.connectStateButton addTarget:self action:@selector(connectStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 特征写
    self.characteristicWriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendDataView addSubview:self.characteristicWriteButton];
    [self.characteristicWriteButton setTitle:@"设置特征写" forState:UIControlStateNormal];
    self.characteristicWriteButton.backgroundColor = [UIColor RandomColor];
    self.characteristicWriteButton.titleLabel.textColor = [UIColor RandomColor];
    self.characteristicWriteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.characteristicWriteButton addTarget:self action:@selector(characteristicWriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 特征读
    self.characteristicReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendDataView addSubview:self.characteristicReadButton];
    [self.characteristicReadButton setTitle:@"设置特征读/通知" forState:UIControlStateNormal];
    self.characteristicReadButton.backgroundColor = [UIColor RandomColor];
    self.characteristicReadButton.tintColor = [UIColor RandomColor];
    self.characteristicReadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.characteristicReadButton addTarget:self action:@selector(characteristicReadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 循环发送输入框
    self.loopSendTextField = [[UITextField alloc] init];
    [self.sendDataView addSubview:self.loopSendTextField];
    self.loopSendTextField.placeholder = @"1";
    // 循环发送button
    self.loopSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendDataView addSubview:self.loopSendButton];
    [self.loopSendButton setTitle:@"循环发送" forState:UIControlStateNormal];
    self.loopSendButton.backgroundColor = [UIColor RandomColor];
    self.loopSendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.loopSendButton addTarget:self action:@selector(loopSendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 命令列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // 清除多余cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"]; // 注册cell
    // 接收区域
    self.receiveView = [[UIView alloc] init];
    [self.view addSubview:self.receiveView];
    self.receiveView.backgroundColor = [UIColor RandomColor];
    // 清除button
    self.cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.receiveView addSubview:self.cleanButton];
    [self.cleanButton setTitle:@"清除" forState:UIControlStateNormal];
    self.cleanButton.backgroundColor = [UIColor RandomColor];
    self.cleanButton.titleLabel.textColor = [UIColor RandomColor];
    self.cleanButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.cleanButton addTarget:self action:@selector(cleanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 命令+
    self.cmdAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.receiveView addSubview:self.cmdAddButton];
    self.cmdAddButton.backgroundColor = [UIColor RandomColor];
    [self.cmdAddButton setTitle:@"指令+" forState:UIControlStateNormal];
    self.cmdAddButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.cmdAddButton addTarget:self action:@selector(cmdAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 命令-
    self.cmdSubButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.receiveView addSubview:self.cmdSubButton];
    self.cmdSubButton.backgroundColor = [UIColor RandomColor];
    [self.cmdSubButton setTitle:@"指令-" forState:UIControlStateNormal];
    self.cmdSubButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.cmdSubButton addTarget:self action:@selector(cmdSubButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 接收区域文本
    self.receiveTextView = [[UITextView alloc] init];
    [self.view addSubview:self.receiveTextView];
    self.receiveTextView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 代码约束布局
- (void)masonryLayout {
    // 发送区View
    [self.sendDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.height.offset(40.0f);
    }];
    // 连接button
    [self.connectStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.characteristicWriteButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.sendDataView.mas_centerY).multipliedBy(1.0f);
    }];
    // 特征写button
    [self.characteristicWriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.characteristicReadButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.sendDataView.mas_centerY).multipliedBy(1.0f);
    }];
    // 特征读button
    [self.characteristicReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loopSendTextField.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.sendDataView.mas_centerY).multipliedBy(1.0f);
    }];
    // 循环发送 时间间隔 输入框
    [self.loopSendTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loopSendButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.sendDataView.mas_centerY).multipliedBy(1.0f);
    }];
    // 循环发送 button
    [self.loopSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendDataView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.sendDataView.mas_centerY).multipliedBy(1.0f);
    }];
    // 列表
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendDataView.mas_bottom).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
    }];
    // 接收View
    [self.receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.height.offset(40.0f);
    }];
    // 清除button
    [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cmdSubButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.receiveView.mas_centerY).multipliedBy(1.0f);
    }];
    // 指令-
    [self.cmdSubButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cmdAddButton.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.receiveView.mas_centerY).multipliedBy(1.0f);
    }];
    // 指令+
    [self.cmdAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.receiveView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.receiveView.mas_centerY).multipliedBy(1.0f);
    }];
    // 接收显示文本
    [self.receiveTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveView.mas_bottom).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.3f);
    }];
}

#pragma mark - 按钮动作
// 连接状态
- (void)connectStateButtonAction:(UIButton *)button {
    NSLog(@"是否连接");
}
// 特征写
- (void)characteristicWriteButtonAction:(UIButton *)button {
    NSLog(@"特征写");
}
// 特征读
- (void)characteristicReadButtonAction:(UIButton *)button {
    NSLog(@"特征读");
}
// 清除
- (void)cleanButtonAction:(UIButton *)button {
    NSLog(@"清除");
}
// 循环发送
- (void)loopSendButtonAction:(UIButton *)button {
    NSLog(@"循环发送");
}
// 指令+
- (void)cmdAddButtonAction:(UIButton *)button {
    NSLog(@"指令+");
}
// 指令-
- (void)cmdSubButtonAction:(UIButton *)button {
    NSLog(@"指令-");
}

#pragma mark - 实现TableView的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark - 实现代理协议
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"更新状态");
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([peripheral.identifier.UUIDString isEqual:self.peripheral.identifier.UUIDString]) {
        // 保存该设备 必须要保存遍历到的设备
        self.peripheral = peripheral;
        // 蓝牙设备设置代理
        peripheral.delegate = self;
        // 连接蓝牙设备
        [central connectPeripheral:peripheral options:nil];
    }
}

// 已经连接设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"已经连接设备");
    // 扫描外部设备的服务
    [peripheral discoverServices:nil];
    // 停止扫描
    [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接设备失败 设备：%@ 错误：%@", peripheral, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"断开设备连接 设备：%@ 错误：%@", peripheral, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    //NSLog(@"设备所带的服务：%@", peripheral.services);
    // 遍历设备自带的特征
    for (CBService *service in peripheral.services) {
        // 扫描发现特征 特征设置为空 便可扫描所有
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"服务的特征：%@", service.characteristics);
    // 初始化数组
    if (self.characteristicsArray == NULL) {
        self.characteristicsArray = [[NSMutableArray alloc] init];
    }
    // 遍历特征
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([self.characteristicsArray containsObject:characteristic] == NO) {
            // 特征数组不包含该特征 就加入到数组
            [self.characteristicsArray addObject:characteristic];
        }
    }
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
