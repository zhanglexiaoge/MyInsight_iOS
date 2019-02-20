//
//  DeviceConfigViewController.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/17.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "EncodeViewController.h" //编码配置
#import "AlarmDetectViewController.h" //报警配置
#import "RecordViewController.h" //录像配置
#import "ParamViewController.h" //图像配置
#import "TimeSynViewController.h" //时间同步
#import "VideoFileViewController.h" //设备录像查询
#import "PictureFileViewController.h"//设备图片查询
#import "PasswordViewController.h" //密码修改
#import "StorageViewController.h" //存储空间
#import "AboutDeviceViewController.h" //关于设备信息
#import "UpgradeDeviceViewController.h" //设备升级
#import "DeviceconfigTableViewCell.h"
#import "DeviceConfigViewController.h"
#import "SystemInfoConfig.h"
#import "DeviceManager.h"
#import "CloudAbilityViewController.h"
#import "AlarmMessageViewController.h"  //推送消息
#import "EncodingFormatViewController.h"  //编码格式设置
#import "AnalyzerViewController.h"  //智能分析
#import "SystemFunctionConfig.h"
#import "WaterMarkViewController.h"       //水印设置
#import "BuzzerViewController.h"            //蜂鸣功能
#import "HumanDetectionViewController.h"  //人形检测

@interface DeviceConfigViewController ()<UITableViewDelegate,UITableViewDataSource,SystemInfoConfigDelegate>

@property (nonatomic, strong) UITableView *devConfigTableView;

@property (nonatomic, strong) NSArray *configTitleArray;

@property (nonatomic, strong) SystemInfoConfig * config;

@property (nonatomic, strong) SystemFunctionConfig * functionConfig;

@end

@implementation DeviceConfigViewController

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
    [[NSNotificationCenter defaultCenter] postNotificationName:MasterAccount object:@"123"];
    //设置导航栏样式
    [self setNaviStyle];
    
    //初始化数据
    [self initDataSource];
    
    //配置子视图
    [self configSubView];
    
     //获取各个设备配置前，如果设备(门铃门锁等等)是在休眠状态，需要先进行唤醒
    [self checkDeviceSleepType];
    
    //获取设备能力级SystemFunction
    [self getSystemFunction];
    
    //获取设备信息systeminfo
    [self getSysteminfo];
}

//获取设备能力级SystemFunction
- (void)getSystemFunction{
    if (!_functionConfig) {
        _functionConfig = [[SystemFunctionConfig alloc] init];
    }
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    [_functionConfig getSystemFunction:channel.deviceMac];
}
//编码配置需要知道设备的模拟通道数量，所以在编码配置前需要获取一下
- (void)getSysteminfo {
    if (_config == nil) {
        _config = [[SystemInfoConfig alloc] init];
        _config.delegate = self;
    }
    [SVProgressHUD show];
     [_config getSystemInfo];
}
//休眠中的设备需要先唤醒才能去获取其他配置
- (void)checkDeviceSleepType {
    ChannelObject *object = [[DeviceControl getInstance] getSelectChannel];
    [[DeviceManager getInstance] deviceWeakUp:object.deviceMac];
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
    
    NSString *detailInfo = [self.configTitleArray[indexPath.row] objectForKey:@"detailInfo"];
    if (detailInfo && detailInfo.length > 0) {
        cell.Labeltext.frame = CGRectMake(64, 9, ScreenWidth - 64, 22);
        cell.detailLabel.hidden = NO;
        cell.Labeltext.text = [self.configTitleArray[indexPath.row] objectForKey:@"title"];
        cell.detailLabel.text = detailInfo;
    }else{
        cell.Labeltext.frame = CGRectMake(64, 18, ScreenWidth - 64, 22);
        cell.detailLabel.hidden = YES;
        cell.Labeltext.text = [self.configTitleArray[indexPath.row] objectForKey:@"title"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = [self.configTitleArray[indexPath.row] objectForKey:@"title"];
    if ([titleStr isEqualToString:TS("alarm_config")]) {
        AlarmDetectViewController *alarmDetectVC = [[AlarmDetectViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:alarmDetectVC animated:NO];
    }else if ([titleStr isEqualToString:TS("Encode_config")]){ //编码配置
        EncodeViewController *encodeVC = [[EncodeViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:encodeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("Record_config")]){ //录像配置
        RecordViewController *encodeVC = [[RecordViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:encodeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("picture_vonfig")]){ //图像配置
        ParamViewController *encodeVC = [[ParamViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:encodeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("time_syn")]){ //时间同步
        TimeSynViewController *timeVC = [[TimeSynViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:timeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("record_file")]){ //设备录像
        VideoFileViewController *videoVC = [[VideoFileViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:videoVC animated:NO];
    }else if ([titleStr isEqualToString:TS("picture_file")]){  //设备图片
        PictureFileViewController *pictureVC = [[PictureFileViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:pictureVC animated:NO];
    }else if ([titleStr isEqualToString:TS("password_change")]){ //修改密码
        PasswordViewController *passwordVC = [[PasswordViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:passwordVC animated:NO];
    }else if ([titleStr isEqualToString:TS("device_storage")]){ //设备存储
        StorageViewController *storageVC = [[StorageViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:storageVC animated:NO];
    }else if ([titleStr isEqualToString:TS("About_Device")]){ //关于设备
        AboutDeviceViewController *deviceVC = [[AboutDeviceViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:deviceVC animated:NO];
    }else if ([titleStr isEqualToString:TS("Equipment_Update")]){ //设备升级
        UpgradeDeviceViewController *upgradeVC = [[UpgradeDeviceViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:upgradeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("Alarm_message_push")]){ //推送消息
        AlarmMessageViewController *alarmMessageVC = [[AlarmMessageViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:alarmMessageVC animated:NO];
        
    }else if ([titleStr isEqualToString:TS("AnalyzeConfig")]){ //智能分析
        ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
        DeviceObject *object  = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
        if(object.sysFunction.NewVideoAnalyze == NO){
            [SVProgressHUD showErrorWithStatus:TS("EE_MNETSDK_NOTSUPPORT")];
            return;
        }
        AnalyzerViewController *analyzeVC = [[AnalyzerViewController alloc] init];
        [self.navigationController pushViewController:analyzeVC animated:NO];
    }else if ([titleStr isEqualToString:TS("Encoding_format")]){ //视频格式
        ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
        DeviceObject *object  = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
        if(object.sysFunction.SupportSmartH264 == NO){
            [SVProgressHUD showErrorWithStatus:TS("EE_MNETSDK_NOTSUPPORT")];
            return;
        }
        EncodingFormatViewController *formatVC = [[EncodingFormatViewController alloc] init];
        [self.navigationController pushViewController:formatVC animated:NO];
    }else if([titleStr isEqualToString:TS("Watermark_setting")]){ //水印
        WaterMarkViewController *waterMarkVC = [[WaterMarkViewController alloc] init];
        [self.navigationController pushViewController:waterMarkVC animated:NO];
    }else if([titleStr isEqualToString:TS("Cloud_storage")]){ //云服务
        CloudAbilityViewController *cloudVC = [[CloudAbilityViewController alloc] init];
        [self.navigationController pushViewController:cloudVC animated:NO];
    }else if([titleStr isEqualToString:TS("Buzzer_setting")]){
        BuzzerViewController *BuzzerVC = [[BuzzerViewController alloc] init];
        [self.navigationController pushViewController:BuzzerVC animated:NO];
    }else if([titleStr isEqualToString:TS("appEventHumanDetectAlarm")]){
        HumanDetectionViewController *humandetectVC = [[HumanDetectionViewController alloc] init];
        [self.navigationController pushViewController:humandetectVC animated:NO];
    }else{
        return;
    }
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("setting");
}


- (void)configSubView {
    [self.view addSubview:self.devConfigTableView];
}
- (void)initDataSource {
    self.configTitleArray = @[
                              @{@"title":TS("Encode_config"),@"detailInfo":@"在这里,你可以配置分辨率,帧数,音频,视频"},
                              @{@"title":TS("alarm_config"),@"detailInfo":@"设备支持各种报警触发和联动,您可以在这里进行配置"},
                              @{@"title":TS("Record_config"),@"detailInfo":@"在这里,你可以配置分辨率,帧数,音频,视频"},
                              @{@"title":TS("picture_vonfig"),@"detailInfo":@"在这里,你可以配置分辨率,帧数,音频,视频"},
                              @{@"title":TS("time_syn"),@"detailInfo":@"在这里可以显示和同步设备时间"},
                              @{@"title":TS("device_storage"),@"detailInfo":@"该选项允许您查看和管理设备的存储空间"},
                              @{@"title":TS("password_change"),@"detailInfo":@"您可以更改设备的访问密码"},
                              @{@"title":TS("record_file"),@"detailInfo":@"设备端保存的普通录像和报警录像等等，必须有存储空间的设备才有录像"},
                              @{@"title":TS("picture_file"),@"detailInfo":@"设备端保存的报警抓图等等，必须有存储空间的设备才有图片"},
                              @{@"title":TS("Alarm_message_push"),@"detailInfo":@""},
                              @{@"title":TS("About_Device"),@"detailInfo":@""},
                              @{@"title":TS("Equipment_Update"),@"detailInfo":@""},
                              @{@"title":TS("AnalyzeConfig"),@"detailInfo":@""},
                              @{@"title":TS("Cloud_storage"),@"detailInfo":@""},
                              @{@"title":TS("Encoding_format"),@"detailInfo":@""},
                              @{@"title":TS("Watermark_setting"),@"detailInfo":@""},
                              @{@"title":TS("Buzzer_setting"),@"detailInfo":@""},
                              @{@"title":TS("appEventHumanDetectAlarm"),@"detailInfo":@""},
                              @{@"title":@"GB配置",@"detailInfo":@""},
                              @{@"title":@"Json和DevCmd调试",@"detailInfo":@""},
                              @{@"title":@"鱼眼信息",@"detailInfo":@""}];
}
@end
