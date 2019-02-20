//
//  TimeSynViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/12.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "TimeSynViewController.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
#import "TimeSynConfig.h"

@interface TimeSynViewController () <UITableViewDelegate,UITableViewDataSource,TimeSynConfigDelegate>
{
    TimeSynConfig *config; //时间同步，包括夏令时、时区、时间等
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation TimeSynViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    //获取设备时间信息
    [self getTimeSynConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取设备夏令时，时区、时间信息
- (void)getTimeSynConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[TimeSynConfig alloc] init];
        config.delegate = self;
    }
    //调用获取设备时间信息的接口
    [config getTimeZoneConfig];
}
#pragma mark 获取摄像机时间代理回调
- (void)getTimeSynConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.tableV reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - 保存摄像机时间配置 （时区、夏令时、时间）
-(void)saveConfig{
    [SVProgressHUD show];
    [config setTimeSynConfig];
}
#pragma mark 保存摄像机时间代理回调
- (void)setTimeSynConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;

    if ([title isEqualToString:TS("summer")]) {
        cell.Labeltext.text =  [config getDSTRule];
    }else if ([title isEqualToString:TS("time_zone")]) {
        cell.Labeltext.text =[config getTimeZone];
    }else if ([title isEqualToString:TS("time")]) {
        cell.Labeltext.text =[config getTimeQuery];
    }else if([title isEqualToString:TS("Time_synch")]){
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    if ([titleStr isEqualToString:TS("Time_synch")]) {
        [config setTimeSynConfig];
    }
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.tableV];
}
- (UITableView *)tableV {
    if (!tableV) {
        tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        tableV.delegate = self;
        tableV.dataSource = self;
        [tableV registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return tableV;
}
#pragma mark - 界面和数据初始化
- (void)initDataSource {
    titleArray = (NSMutableArray*)@[TS("summer"),TS("time_zone"),TS("time"),TS("Time_synch")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
