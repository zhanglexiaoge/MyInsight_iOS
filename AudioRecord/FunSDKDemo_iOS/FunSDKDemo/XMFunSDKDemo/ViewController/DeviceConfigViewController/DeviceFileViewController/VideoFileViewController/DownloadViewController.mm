//
//  DownloadViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/15.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "DownloadViewController.h"
#import "VideoFileDownloadConfig.h"
#import "ItemTableviewCell.h"
@interface DownloadViewController () <UITableViewDelegate,UITableViewDataSource,FileDownloadDelegate>
{
    VideoFileDownloadConfig *config;
    UITableView *tableV;
    RecordInfo *record;
    float progres;
}
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
}

#pragma mark - 开始下载设备录像
- (void)startDownloadRecord:(RecordInfo*)recordInfo {
    [SVProgressHUD show];
    record = recordInfo;
    if (config == nil) {
        config = [[VideoFileDownloadConfig alloc] init];
        config.delegate = self;
    }
    [config downloadFile:record];
}

#pragma mark -下载录像开始回调
- (void)fileDownloadStartResult:(NSInteger)result {
    if (result <0) {
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark -下载进度回调
- (void)fileDownloadProgressResult:(float)progress {
    progres = progress;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = [NSArray arrayWithObject:path];
    [tableV reloadRowsAtIndexPaths:array withRowAnimation:nil];
}
#pragma mark -下载录像结果回调
- (void)fileDownloadEndResult {
    [SVProgressHUD dismiss];
    progres = 1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = [NSArray arrayWithObject:path];
    [tableV reloadRowsAtIndexPaths:array withRowAnimation:nil];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (indexPath.row == 0) {
        cell.textLabel.text = record.fileName;
    }else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"fileSize：%ldK",record.fileSize];
    }else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"DownloadProgress: %04f%@",progres*100,@"%"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.title = TS("video_download");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
