//
//  ByFileViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/14.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ByFileViewController.h"
#import "VideoFileConfig.h" //录像查询接口类
#import "DownloadViewController.h" //录像下载
#import "ItemTableviewCell.h"


@interface ByFileViewController () <UITableViewDelegate, UITableViewDataSource, VideoFileConfigDelegate>
{
    VideoFileConfig *config;
    UITableView *tableV;
    NSMutableArray *recordArray;
}
@end

@implementation ByFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    [self getVideoFileConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 按文件查询设备录像信息
- (void)getVideoFileConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[VideoFileConfig alloc] init];
        config.delegate = self;
    }
     //调用按文件查询录像的接口,查询今天的设备录像，可以自己设置日期进行查询
    [config getDeviceVideoByFile:[NSDate date]];
}
#pragma mark 获取摄像机录像代理回调
- (void)getVideoResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        recordArray =[config getVideoFileArray];
        //成功，刷新界面数据
        [self.tableV reloadData];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    RecordInfo *record = [recordArray objectAtIndex:indexPath.row];
    cell.textLabel.text = record.fileName;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        //点击下载录像
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
    RecordInfo *record = [recordArray objectAtIndex:indexPath.row];
    [downloadVC startDownloadRecord:record];
    
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
    recordArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
