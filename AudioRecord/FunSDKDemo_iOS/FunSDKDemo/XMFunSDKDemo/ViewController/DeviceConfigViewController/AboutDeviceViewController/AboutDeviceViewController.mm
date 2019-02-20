//
//  AboutDeviceViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/19.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "AboutDeviceViewController.h"
#import "DeviceconfigTableViewCell.h"
#import "SystemInfoConfig.h"
#import "SystemResetConfig.h"

@interface AboutDeviceViewController () <UITableViewDelegate,UITableViewDataSource,SystemInfoConfigDelegate>

@property (nonatomic, strong) UITableView *devConfigTableView;

@property (nonatomic, strong) NSMutableArray *configTitleArray;

@property (nonatomic, strong) SystemInfoConfig *config;

@property (nonatomic, strong) SystemResetConfig *resetConfig;

@end

@implementation AboutDeviceViewController

- (UITableView *)devConfigTableView {
    if (!_devConfigTableView) {
        _devConfigTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        _devConfigTableView.delegate = self;
        _devConfigTableView.dataSource = self;
        _devConfigTableView.rowHeight = 60;
        [_devConfigTableView registerClass:[DeviceconfigTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _devConfigTableView;
}

#pragma mark -- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setNaviStyle];
    
    //初始化数据
    [self initDataSource];
    
    //配置子视图
    [self configSubView];
    
    //获取设备信息systeminfo
    [self getSysteminfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}
//编码配置需要知道设备的模拟通道数量，所以在编码配置前需要获取一下
- (void)getSysteminfo {
    if (_config == nil) {
        _config = [[SystemInfoConfig alloc] init];
        _config.delegate = self;
    }
    if (_resetConfig == nil){
        _resetConfig = [[SystemResetConfig alloc] init];
    }
    [SVProgressHUD show];
    [_config getSystemInfo];
}
#pragma mark  获取设备systeminfo回调
- (void)SystemInfoConfigGetResult:(NSInteger)result {
    if (result >0) {
        //获取成功
        [SVProgressHUD dismiss];
    }else{
        //获取失败
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark -- UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceconfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DeviceconfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    
    NSString *title = [self.configTitleArray[indexPath.row] objectForKey:@"title"];
    cell.Labeltext.text = title;
    if ([title isEqualToString:TS("serial_number2")]) {
        cell.detailLabel.text = device.deviceMac;
    }
    if ([title isEqualToString:TS("device_type2")]) {
        cell.detailLabel.text = [NSString getDeviceType:device.nType];
    }
    if ([title isEqualToString:TS("soft_version")]) {
        cell.detailLabel.text = device.info.softWareVersion;
    }
    if ([title isEqualToString:TS("hard_version")]) {
        cell.detailLabel.text = device.info.hardWare;
    }
    if ([title isEqualToString:TS("lastUpgreade_time")]) {
        cell.detailLabel.text = device.info.buildTime;
    }
    if ([title isEqualToString:TS("video_format")]) {
        cell.detailLabel.text = [NSString getDeviceNetType:device.info.netType];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [self.configTitleArray[indexPath.row] objectForKey:@"title"];
    if ([title isEqualToString:TS("about_tip")]) {          // 点击恢复出厂设置
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("warm_prompt") message:TS("reset_device") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.resetConfig resetDeviceConfig];
            [SVProgressHUD show];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:comfirmAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (void)setNaviStyle {
    self.navigationItem.title = TS("About_Device");
}


- (void)configSubView {
    [self.view addSubview:self.devConfigTableView];
}
- (void)initDataSource {
    self.configTitleArray = (NSMutableArray*)@[
                              @{@"title":TS("serial_number2"),@"detailInfo":@""},
                              @{@"title":TS("device_type2"),@"detailInfo":@""},
                              @{@"title":TS("soft_version"),@"detailInfo":@""},
                              @{@"title":TS("hard_version"),@"detailInfo":@""},
                              @{@"title":TS("lastUpgreade_time"),@"detailInfo":@""},
                              @{@"title":TS("video_format"),@"detailInfo":@""},
                              @{@"title":TS("about_tip"),@"detailInfo":@""}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
