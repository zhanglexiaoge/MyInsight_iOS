//
//  AlarmDetectViewController.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/21.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "AlarmLevelViewController.h"
#import "AlarmConfigTableViewCell.h"
#import "AlarmDetectViewController.h"

#import "AlarmDetectConfig.h"   //移动侦测

@interface AlarmDetectViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmDetectConfigDelegate>

//灵敏度Lab
@property (nonatomic, strong) UILabel *alarmSensitivityLab;

@property (nonatomic, strong) UITableView *alarmTableView;

//表视图数据源
@property (nonatomic, strong) NSMutableDictionary *dateSourceDic;

@property (nonatomic, strong) AlarmDetectConfig *alarmDetectConfig;
@end

@implementation AlarmDetectViewController{
    BOOL test;
}


- (UILabel *)alarmSensitivityLab {
    if (!_alarmSensitivityLab) {
        _alarmSensitivityLab = [UILabel new];
        _alarmSensitivityLab.textAlignment = NSTextAlignmentRight;
    }
    return _alarmSensitivityLab;
}

- (UITableView *)alarmTableView {
    if (!_alarmTableView) {
        _alarmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _alarmTableView.delegate = self;
        _alarmTableView.dataSource = self;
        _alarmTableView.tableFooterView = [UIView new];
        [_alarmTableView registerClass:[AlarmConfigTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _alarmTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setNaviStyle];
    
    [self configSubView];
    
    //向SDK请求报警数据
    [self getDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

-(void)getDataSource{
    self.dateSourceDic = [@{
                            @"0":@[@"Video_loss_alarm"],
                            @"1":@[@"Alarm_function",@"Alarm_video",@"Alarm_picture",@"Send_to_phone",@"Alarm_Sensitivity"],
                            @"2":@[@"Alarm_function",@"Alarm_video",@"Alarm_picture",@"Send_to_phone"],
                            }
                          mutableCopy];
    //获取报警配置
    [SVProgressHUD showWithStatus:TS("")];
    if (_alarmDetectConfig == nil) {
        _alarmDetectConfig = [[AlarmDetectConfig alloc] init];
        _alarmDetectConfig.delegate = self;
    }
    [_alarmDetectConfig getDeviceAlarmDetectConfig];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("报警配置");
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:TS("保存") style:UIBarButtonItemStyleDone target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)configSubView {
    [self.view addSubview:self.alarmTableView];
}

#pragma mark -- UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 5;
    }else if(section == 2){
        return 4;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2){
        return 50;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    headView.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:0.7];
    UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth, 50)];
    if (section == 0) {
        return nil;
    }else if (section == 1){
        headLab.text = TS("Motion_detection");
    }else if (section == 2){
        headLab.text = TS("Video_block");
    }
    
    [headView addSubview:headLab];
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *dataSourceArray = [self.dateSourceDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    cell.textLabel.text = TS([[dataSourceArray objectAtIndex:indexPath.row] UTF8String]);
    BOOL AlarmSensitivity = (indexPath.section == 1 && indexPath.row == 4);
    if (!AlarmSensitivity) {
        cell.mySwitch.tag = (indexPath.section + 1)*100 +indexPath.row;
        if (cell.mySwitch.tag == 100) {                 //视频丢失报警开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getLossEnable]];
        }else if (cell.mySwitch.tag == 200){            //移动侦测报警功能开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getMotionEnable]];
        }else if (cell.mySwitch.tag == 201){            //移动侦测报警录像开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getMotionRecordEnable]];
        }else if (cell.mySwitch.tag == 202){            //移动侦测报警抓图开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getMotionSnapEnable]];
        }else if (cell.mySwitch.tag == 203){            //移动侦测手机推送开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getMotionMessageEnable]];
        }else if (cell.mySwitch.tag == 300){            //视频遮挡报警功能开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getBlindEnable]];
        }else if (cell.mySwitch.tag == 301){            //视频遮挡报警录像开关
             [cell.mySwitch setOn:[self.alarmDetectConfig getBlindRecordEnable]];
        }else if (cell.mySwitch.tag == 302){            //视频遮挡报警抓图开关
            [cell.mySwitch setOn:[self.alarmDetectConfig getBlindSnapEnable]];
        }else if (cell.mySwitch.tag == 303){            //视频遮挡手机推送开关
             [cell.mySwitch setOn:[self.alarmDetectConfig getBlindMessageEnable]];
        }
    }else{          //移动侦测灵敏度显示刷新
        self.alarmSensitivityLab.frame = CGRectMake(ScreenWidth - 100, 7, 80, 30);
        [cell.contentView addSubview:self.alarmSensitivityLab];
        cell.mySwitch.hidden = YES;
        int bum = [_alarmDetectConfig getMotionlevel];
        if (bum == 1 || bum == 2) {
            self.alarmSensitivityLab.text = TS("Alarm_Lower");
        }else if (bum == 3 || bum == 4){
            self.alarmSensitivityLab.text = TS("Alarm_Middle");
        }else if (bum == 5 || bum == 6){
            self.alarmSensitivityLab.text = TS("Alarm_Anvanced");
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && indexPath.row == 4) {
        AlarmLevelViewController *viewController = [AlarmLevelViewController new];
        __weak typeof(self) weakSelf = self;
        viewController.alarmLevelBlock = ^(NSString *iLevel) {
            weakSelf.alarmSensitivityLab.text = iLevel;
        };
        [self.navigationController pushViewController:viewController animated:NO];
    }
    return;
}

#pragma mark -- 获取报警配置代理回调
- (void)getAlarmDetectConfigResult:(NSInteger)result{
    if (result  >0) {
        [SVProgressHUD dismiss];
        [self.alarmTableView reloadData];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark -- 保存报警配置
-(void)saveConfig{
    
    //视频丢失报警保存
    UISwitch *videoLossSwitch = [self.view viewWithTag:100];
    [_alarmDetectConfig setLossEnable:videoLossSwitch.on];

    //移动侦测配置保存
    UISwitch *alarmFunctionSwitch = [self.view viewWithTag:200];
    UISwitch *alarmRecodeSwitch = [self.view viewWithTag:201];
    UISwitch *alarmSnapSwitch = [self.view viewWithTag:202];
    UISwitch *alarmMessageSwitch = [self.view viewWithTag:203];
    [_alarmDetectConfig setMotionEnable: alarmFunctionSwitch.on];
    [_alarmDetectConfig setMotionRecordEnable: alarmRecodeSwitch.on];
    [_alarmDetectConfig setMotionSnapEnable: alarmSnapSwitch.on];
    [_alarmDetectConfig setMotionMessageEnable: alarmMessageSwitch.on];
//灵敏度保存
    if ([self.alarmSensitivityLab.text isEqualToString:TS("Alarm_Lower")]) {
        [_alarmDetectConfig setMotionlevel: 1];
    }else if ([self.alarmSensitivityLab.text isEqualToString:TS("Alarm_Middle")]){
        [_alarmDetectConfig setMotionlevel: 3];
    }else if ([self.alarmSensitivityLab.text isEqualToString:TS("Alarm_Anvanced")]){
        [_alarmDetectConfig setMotionlevel: 5];
    }

    //视频遮挡配置保存
    UISwitch *alarmFunctionSwitch2 = [self.view viewWithTag:300];
    UISwitch *alarmRecodeSwitch2 = [self.view viewWithTag:301];
    UISwitch *alarmSnapSwitch2 = [self.view viewWithTag:302];
    UISwitch *alarmMessageSwitch2 = [self.view viewWithTag:303];
    [_alarmDetectConfig setBlindEnable: alarmFunctionSwitch2.on];
    [_alarmDetectConfig setBlindRecordEnable: alarmRecodeSwitch2.on];
    [_alarmDetectConfig setBlindSnapEnable: alarmSnapSwitch2.on];
    [_alarmDetectConfig setBlindMessageEnable: alarmMessageSwitch2.on];

    //发送保存配置命令
    [_alarmDetectConfig setDeviceAlarmDetectConfig];
    [SVProgressHUD showWithStatus:TS("")];
}

//保存配置结果回调
-(void)setAlarmDetectConfigResult:(NSInteger)result{
    if (result>0) {
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
    }else{
         [MessageUI ShowErrorInt:(int)result];
    }
}



@end
