//
//  QuickConfigurationViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/15.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "QuickConfigurationViewController.h"
#import "QuickConfigurationView.h"
#import "DeviceManager.h"
#import <Masonry/Masonry.h>

@interface QuickConfigurationViewController ()<DeviceManagerDelegate>
{
    DeviceManager *deviceManager;       //设备管理器
    QuickConfigurationView *configView; //快速配置界面
}
@end

@implementation QuickConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设备管理器
    deviceManager = [[DeviceManager alloc] init];
    deviceManager.delegate = self;
    
    configView = [[QuickConfigurationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.view = configView;
    
    __weak typeof(self) weakSelf = self;
    //开始快速配置
    configView.startConfig = ^(NSString * _Nonnull ssid, NSString * _Nonnull password) {
        [weakSelf startQuickConfiguration:ssid psw:password];
    };
    //停止快速配置
    configView.stopConfig = ^{
        [weakSelf stopQuickConfiguration];
    };
    //添加设备
    configView.addDevice = ^{
        [weakSelf addDevice];
    };
    
    //设置导航栏
    [self setNaviStyle];
}

- (void)viewWillAppear:(BOOL)animated{
    configView.wifiTF.text = [NSString getCurrent_SSID];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("quick_configuration");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - button event
-(void)popViewController{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  开始快速配置
-(void)startQuickConfiguration:(NSString *)ssid psw:(NSString *)password{
    [deviceManager startConfigWithSSID:ssid password:password];
}

#pragma mark  结束快速配置
-(void)stopQuickConfiguration{
    [deviceManager stopConfig];
}

#pragma mark  添加设备
-(void)addDevice{
    DeviceObject *object = [configView.deviceArray objectAtIndex:0];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //通过序列号添加

    [deviceManager addDeviceByDeviseSerialnumber:object.deviceMac deviceName:object.deviceMac devType:object.nType];
}

#pragma mark - funsdk回调处理
-(void)quickConfiguration:(id)device result:(int)resurt{
    if (resurt >= 0) {
        //快速配置成功，刷新界面
        [configView stopTiming];
        [configView.deviceArray removeAllObjects];
        [configView.deviceArray addObject:device];
        [configView createPlayView];
    }
}

@end
