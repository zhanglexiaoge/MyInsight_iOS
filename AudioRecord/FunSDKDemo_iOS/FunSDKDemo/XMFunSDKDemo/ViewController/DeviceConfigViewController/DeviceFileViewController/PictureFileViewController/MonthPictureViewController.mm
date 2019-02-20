//
//  MonthPictureViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "MonthPictureViewController.h"
#import "PictureFileConfig.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
@interface MonthPictureViewController () <UITableViewDelegate, UITableViewDataSource, PictureFileConfigDelegate>
{
    PictureFileConfig *config;
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation MonthPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    [self getPictureFileConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 查询设备图片信息
- (void)getPictureFileConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[PictureFileConfig alloc] init];
        config.delegate = self;
    }
    //调用查询这个月内哪些天有图片的接口，可以自己设置日期进行查询
    [config getMonthPictureDate:[NSDate date]];
}
#pragma mark 获取摄像机参数代理回调
- (void)getPictureResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        titleArray =[[config getMonthPictureArray] mutableCopy];
        //成功，刷新界面数据
        [self.tableV reloadData];
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
    NSString *dateString = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dateString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.title = TS("search_picture_date");
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
    titleArray = [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
