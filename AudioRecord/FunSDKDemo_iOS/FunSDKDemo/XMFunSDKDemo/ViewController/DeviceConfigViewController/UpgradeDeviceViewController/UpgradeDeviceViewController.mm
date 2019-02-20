//
//  UpgradeDeviceViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/26.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "UpgradeDeviceViewController.h"
#import "UpgradeConfig.h"
#import "ItemTableviewCell.h"

@interface UpgradeDeviceViewController () <UITableViewDelegate,UITableViewDataSource,UpgradeConfigDelegate>
{
    UpgradeConfig *config; //设备版本升级
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation UpgradeDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    //获取设备版本升级信息
    [self upgradeCheckDevice];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取设备版本升级信息
- (void)upgradeCheckDevice {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[UpgradeConfig alloc] init];
        config.delegate = self;
    }
    //调用获取设备版本升级信息的接口
    [config upgradeCheckDevice];
}
#pragma mark - 开始升级设备
-(void)saveConfig{
    [SVProgressHUD show];
    [config upgradeStartDevice];
}
#pragma mark 设备固件版本检查回调
- (void)upgradeCheckResult:(int)result {
    if (result  == 0 || result == 1 || result == 2) {
        //检查版本成功，刷新界面
        [tableV reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark 设备固件版本升级结果回调
- (void)upgradeStartDeviceResult:(int)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Resource_Download")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark 设备升级进度回调
-(void)upgradeProgressDeviceResult {
    //进度有刷新，刷新界面
    [tableV reloadData];
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
    if ([title isEqualToString:TS("device_Version")]) {
        cell.Labeltext.text = [config getUpgradeCheckState];
    }else if ([title isEqualToString:TS("upgrade_State")]) {
        cell.Labeltext.text =[config getUpgradeState];
    }else if ([title isEqualToString:TS("upgrade_progress")]) {
        float progress = [config getUpgradeProgress];
        if (progress == 0) {
            return cell;
        }
        cell.Labeltext.text =[NSString stringWithFormat:@"%.1f",progress] ;
    }else if([title isEqualToString:TS("Equipment_Update")]){
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    if ([titleStr isEqualToString:TS("Equipment_Update")]) {
        [SVProgressHUD show];
        //开始升级设备
        [config upgradeStartDevice];
    }
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(saveConfig)];
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
    titleArray=(NSMutableArray*)@[TS("device_Version"),TS("upgrade_State"),TS("upgrade_progress"),TS("Equipment_Update")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
