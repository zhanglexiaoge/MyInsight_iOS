//
//  CloudphotoDayVController.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/3.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudphotoDayVController.h"
#import "CloudPhotoDownloadViewController.h"
#import "ItemTableviewCell.h"
#import "NSDate+TimeCategory.h"

@interface CloudphotoDayVController () <UITableViewDelegate, UITableViewDataSource, CloudPhotoConfigDelegate>
{
    CloudPhotoConfig *config;
    UITableView *tableV;
    NSMutableArray *pictureArray;
}
@end

@implementation CloudphotoDayVController

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

#pragma mark - 按文件查询设备图片信息
- (void)getVideoFileConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[CloudPhotoConfig alloc] init];
        config.delegate = self;
    }
    //查询今天的云图片，可以设置其他想要查询的日期
    [config searchCloudPicture:[NSDate dateFromString:self.dateStr format: DATEFORMATER ]];
}
#pragma mark 获取云图片代理回调
- (void)getCloudPictureResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        pictureArray = [config getCloudPictureFileArray];
        //成功，刷新界面数据
        [self.tableV reloadData];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return pictureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    XMAlarmMsgResource *pic = [pictureArray objectAtIndex:indexPath.row];
    //云图片时间和类型
    cell.textLabel.text = pic.startTime;
    cell.Labeltext.text = [pic getEventString];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击下载云图片
    CloudPhotoDownloadViewController *downloadVC = [[CloudPhotoDownloadViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
    XMAlarmMsgResource *recource = [pictureArray objectAtIndex:indexPath.row];
    [downloadVC startDownloadCloudPicture:recource];
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.title = TS("search_picture");
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
    pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
