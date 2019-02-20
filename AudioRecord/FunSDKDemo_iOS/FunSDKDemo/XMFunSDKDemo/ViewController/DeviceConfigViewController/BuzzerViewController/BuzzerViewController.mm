//
//  BuzzerViewController.m
//  FunSDKDemo
//
//  Created by Levi on 2019/1/4.
//  Copyright © 2019年 Levi. All rights reserved.
//

#import "BuzzerConfig.h"
#import "BuzzerViewController.h"

@interface BuzzerViewController ()<BuzzerConfigDelegate,UITableViewDelegate,UITableViewDataSource>{
    BuzzerConfig *config;
}

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UISwitch *mySwitch;

@property (nonatomic, assign) BOOL alarmBellState;

@end

@implementation BuzzerViewController

#pragma mark -- LazyLoad
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}

-(UISwitch *)mySwitch{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_mySwitch addTarget:self action:@selector(transformAlarmBellState:) forControlEvents:UIControlEventValueChanged];
    }
    return _mySwitch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self configSubViews];
    
    [self getBuzzerConfig];
}

#pragma mark -- alarmBellState default NO
-(void)initData{
    self.alarmBellState = NO;
}

-(void)configSubViews{
    [self.view addSubview:self.myTableView];
}

#pragma mark --getConfigAboutDeviceBuzzerState
-(void)getBuzzerConfig{
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[BuzzerConfig alloc] init];
        config.delegate = self;
    }
    [config getDeviceBuzzerAlarmConfig];
}

#pragma mark --getConfigAboutDeviceBuzzerStateResult
-(void)getDeviceBuzzerAlarmConfigResult:(BOOL)AlarmBellState{
    self.alarmBellState = AlarmBellState;
    [self.myTableView reloadData];
}

#pragma mark --setConfigAboutDeviceBuzzerStateResult
- (void)setDeviceBuzzerAlarmConfigResult:(int)result{
    if (result <0) {
        [MessageUI ShowErrorInt:result];
    }else{
        [SVProgressHUD showSuccessWithStatus:TS("config_Save_Success") duration:1.5f];
    }
}

#pragma mark -- UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text = TS("Buzzer_setting");
    cell.accessoryView = self.mySwitch;
    self.mySwitch.on = self.alarmBellState;
    return cell;
}

-(void)transformAlarmBellState:(UISwitch *)sender{
    [config setDeviceBuzzerAlarmConfig:sender.on];
}

@end
