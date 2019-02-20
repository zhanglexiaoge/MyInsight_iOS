//
//  StorageViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/18.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "StorageViewController.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
#import "StorageConfig.h"

@interface StorageViewController () <UITableViewDelegate,UITableViewDataSource,StorageConfigDelegate>
{
    StorageConfig *config; //摄像机参数配置 （图像翻转等等）
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation StorageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    // 获取设备存储配置
    [self getDeviceStorageConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取设备存储配置
- (void)getDeviceStorageConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[StorageConfig alloc] init];
        config.delegate = self;
    }
    //调用获取设备存储配置的接口
    [config getStorageInfoConfig];
}
#pragma mark 设备存储信息结果回调
- (void)requestDeviceStorageResult:(NSInteger)result; {
    if (result >0) {
        //成功，刷新界面数据
        [self.tableV reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark 保存设备普通录像的循环录像代理回调
- (void)setOverWrightConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark 保存设备原始录像的循环录像代理回调
- (void)setKeyOverWrightConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark 格式化设备存储空间代理回调
- (void)clearStorageResult:(NSInteger)result {
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
    if (config.storage.totalStorage <=0.01) { //数据异常，直接return
        return cell;
    }
    if ([title isEqualToString:TS("Total_Capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.totalStorage];
    }else if ([title isEqualToString:TS("Residual_Capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.freeStorage];
    }else if ([title isEqualToString:TS("video_Capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.videoTotalStorage];
    }else if ([title isEqualToString:TS("video_re_capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.videoFreeStorage];
    }else if ([title isEqualToString:TS("picture_Capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.imgTotalStorage];
    }else if ([title isEqualToString:TS("picture_re_capacity")]) {
        cell.Labeltext.text =  [NSString stringWithFormat:@"%.01fK",config.storage.imgFreeStorage];
    }else if ([title isEqualToString:TS("Is_Cover")]) { //普通设备只需要考虑这个清空配置就可以了
        cell.Labeltext.text = [NSString stringWithFormat:@"%@",config.storage.overWright];
    }else if ([title isEqualToString:TS("orginal_Is_Cover")]) { //这个只有一部分设备支持，例如：勇士相机等等
        cell.Labeltext.text = [NSString stringWithFormat:@"%@",config.storage.keyOverWrite];
    }else if ([title isEqualToString:TS("clean_storage")]) {
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    //初始化各个配置的item单元格
    ItemViewController *itemVC = [[ItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    //循环录像配置和格式化配置不能同时设置，必须有先后顺序
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.tableV cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
        if ([cell.textLabel.text isEqualToString:TS("Is_Cover")]) {
            [SVProgressHUD show];
            [config setOverWrightConfig:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("orginal_Is_Cover")]) {
            [SVProgressHUD show]; //这个只有一部分设备支持，勇士类设备
            [config setKeyOverWrightConfig:encodeString];
        }else{
            return;
        }
    };
    //点击单元格之后进行分别赋值
    if ([titleStr isEqualToString:TS("Is_Cover")]) {
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("orginal_Is_Cover")]) {
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else  if ([titleStr isEqualToString:TS("clean_storage")]){
        //格式化
        [SVProgressHUD show];
        [config clearStorage];
        return;
    }
    //如果赋值成功，跳转到下一级界面
    [self.navigationController pushViewController:itemVC animated:YES];
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
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
    titleArray = (NSMutableArray*)@[TS("Total_Capacity"),TS("Residual_Capacity"),TS("video_Capacity"),TS("video_re_capacity"),TS("picture_Capacity"),TS("picture_re_capacity"),TS("Is_Cover"),TS("orginal_Is_Cover"),TS("clean_storage")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
