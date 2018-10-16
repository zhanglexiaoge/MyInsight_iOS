//
//  AdvanceVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "AdvanceVC.h"
#import <SWRevealViewController.h>
#import <Masonry.h>
#import "TouchIDVC.h" // TouchID
#import "MapsVC.h" // 地图
#import "BlueToothVC.h" // 蓝牙(系统)
#import "BabyBleVC.h" // 蓝牙(三方)
#import "MQTTVC.h"
#import "NetWorkVC.h" // 网络请求
#import "DataBaseVC.h"
#import "QRCodeVC.h"
#import "EncryptVC.h" //RSAEncrypt加密解密
#import "PushMsgVC.h"
#import "FileSharedVC.h"
#import "PaymentVC.h" // 支付方式
#import "SensorVC.h" // 传感器
#import "HardwareInfoVC.h" // 硬件信息

@interface AdvanceVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数组数据
@property (nonatomic, strong) NSArray *dataArray;

@end

// 定义字符串
static const NSString *TouchIDStr = @"TouchID";
static const NSString *MapsStr = @"地图";
static const NSString *BlueToothStr = @"蓝牙(系统)";
static const NSString *BabyBLEStr = @"蓝牙(三方)";
static const NSString *MQTTStr = @"MQTT";
static const NSString *NetWorkStr = @"网络请求";
static const NSString *DataBaseStr = @"数据库";
static const NSString *QRCodeString = @"二维码";
static const NSString *RSAEncryptStr = @"数据加密";
static const NSString *PushMsgStr = @"推送消息";
static const NSString *FileSharedStr = @"文件共享";
static const NSString *PaymentStr = @"支付方式";
static const NSString *SensorStr = @"传感器";
static const NSString *HardwareInfoStr = @"硬件信息";

@implementation AdvanceVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self revealViewController] != NULL) {
        [[self revealViewController] tapGestureRecognizer];
        [self.view addGestureRecognizer:[self revealViewController].panGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self revealViewController] != NULL) {
        [self.view removeGestureRecognizer:[self revealViewController].panGestureRecognizer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左右button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:[self revealViewController] action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStylePlain target:[self revealViewController] action:@selector(rightRevealToggle:)];
    
    // 处理数据
    [self handleTableViewData];
    // 创建列表
    [self creatTableView];
    // 代码约束布局
    [self masonryLayoutSubview];
}

// 处理数据
- (void)handleTableViewData {
    self.dataArray = @[TouchIDStr, MapsStr, BlueToothStr, BabyBLEStr, MQTTStr, DataBaseStr, NetWorkStr, QRCodeString, RSAEncryptStr, PushMsgStr, FileSharedStr, PaymentStr, SensorStr, HardwareInfoStr];
}

#pragma mark - 创建TableView
- (void)creatTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    // 设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 清空多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    //[self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - 实现TableView的代理协议
// section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// section中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"MineCell" owner:self options:nil] lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:TouchIDStr]) {
        // TouchID
        TouchIDVC *touchIDVC = [[TouchIDVC alloc] init];
        touchIDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:touchIDVC animated:YES];
    }
    if ([cellString isEqual:MapsStr]) {
        //  地图
        MapsVC *mapsVC = [[MapsVC alloc] init];
        mapsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mapsVC animated:YES];
    }
    if ([cellString isEqual:DataBaseStr]) {
        // 数据库
        DataBaseVC *dataBaseVC = [[DataBaseVC alloc] init];
        dataBaseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dataBaseVC animated:YES];
    }
    if ([cellString isEqual:BlueToothStr]) {
        // 蓝牙(系统)
        BlueToothVC *blueToothVC = [[BlueToothVC alloc] init];
        blueToothVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:blueToothVC animated:YES];
    }
    if ([cellString isEqual:BabyBLEStr]) {
        // 蓝牙(三方)
        BabyBleVC *babyBleVC = [[BabyBleVC alloc] init];
        babyBleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:babyBleVC animated:YES];
    }
    if ([cellString isEqual:MQTTStr]) {
        // MQTT
        MQTTVC *mqttVC = [[MQTTVC alloc] init];
        mqttVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mqttVC animated:YES];
    }
    if ([cellString isEqual:NetWorkStr]) {
        // 网络请求
        NetWorkVC *netWorkVC = [[NetWorkVC alloc] init];
        netWorkVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:netWorkVC animated:YES];
    }
    if ([cellString isEqual:QRCodeString]) {
        // 二维码
        QRCodeVC *qrcodeVC = [[QRCodeVC alloc] init];
        qrcodeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qrcodeVC animated:YES];
    }
    if ([cellString isEqual:RSAEncryptStr]) {
        // 数据加密解密
        EncryptVC *encryptVC= [[EncryptVC alloc] init];
        encryptVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:encryptVC animated:YES];
    }
    if ([cellString isEqual:PushMsgStr]) {
        // 推送消息
        PushMsgVC *pushMsgVC= [[PushMsgVC alloc] init];
        pushMsgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushMsgVC animated:YES];
    }
    if ([cellString isEqual:FileSharedStr]) {
        // 文件共享
        FileSharedVC *fileSharedVC= [[FileSharedVC alloc] init];
        fileSharedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fileSharedVC animated:YES];
    }
    if ([cellString isEqual:PaymentStr]) {
        // 支付方式
        PaymentVC *paymentVC= [[PaymentVC alloc] init];
        paymentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:paymentVC animated:YES];
    }
    if ([cellString isEqual:SensorStr]) {
        // 传感器
        SensorVC *sensorVC= [[UIStoryboard storyboardWithName:@"Advance" bundle:NULL] instantiateViewControllerWithIdentifier:@"SensorVC"];
        sensorVC.hidesBottomBarWhenPushed = YES;
        sensorVC.title = cellString;
        [self.navigationController pushViewController:sensorVC animated:YES];
    }
    if ([cellString isEqual:HardwareInfoStr]) {
        // 硬件信息
        HardwareInfoVC *hardwareInfoVC= [[HardwareInfoVC alloc] init];
        hardwareInfoVC.hidesBottomBarWhenPushed = YES;
        hardwareInfoVC.title = cellString;
        [self.navigationController pushViewController:hardwareInfoVC animated:YES];
    }
}

#pragma mark - 代码约束布局
- (void)masonryLayoutSubview {
    // TableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
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
