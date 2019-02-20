//
//  CloudVideoDayViewController.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/7.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudVideoDayViewController.h"
#import "CloudVideoDownloadViewController.h"
#import "ItemTableviewCell.h"
#import "NSDate+TimeCategory.h"

@interface CloudVideoDayViewController ()<UITableViewDelegate, UITableViewDataSource, CloudVideoConfigDelegate>
{
    CloudVideoConfig *config;
    UITableView *tableV;
    NSMutableArray *videoArray;
}
@end

@implementation CloudVideoDayViewController

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

#pragma mark - 查询设备云存储视频信息
- (void)getVideoFileConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[CloudVideoConfig alloc] init];
        config.delegate = self;
    }
    //查询今天的云图片，可以设置其他想要查询的日期
    [config searchCloudVideo:[NSDate dateFromString:self.dateStr format: DATEFORMATER ]];
}
#pragma mark 获取云图片代理回调
- (void)getCloudVideoResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        videoArray = [config getCloudVideoFileArray];
        //成功，刷新界面数据
        [self.tableV reloadData];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CLouldVideoResource *resource = [videoArray objectAtIndex:indexPath.row];
    //云图片时间和日期
    cell.textLabel.text = resource.beginDate;
    cell.Labeltext.text = resource.beginTime;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击下载云图片
    CloudVideoDownloadViewController *downloadVC = [[CloudVideoDownloadViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
    CLouldVideoResource *recource = [videoArray objectAtIndex:indexPath.row];
    [downloadVC startDownloadCloudVideo:recource];
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.title = TS("search_Video");
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
    videoArray = [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
