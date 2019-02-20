//
//  CloudVideoDownloadViewController.m
//  FunSDKDemo
//
//  Created by XM on 2019/1/7.
//  Copyright © 2019年 XM. All rights reserved.
//

#import "CloudVideoDownloadViewController.h"
#import "ItemTableviewCell.h"

@interface CloudVideoDownloadViewController ()
<UITableViewDelegate,UITableViewDataSource,CloudVideoConfigDelegate>
{
    CloudVideoConfig *config;
    CLouldVideoResource *resource;
    UITableView *tableV;
    NSString *thumbPath;
    NSString *videoPath;
    float progres;
}
@end

@implementation CloudVideoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
}

#pragma mark - 开始下载云视频录像
- (void)startDownloadCloudVideo:(CLouldVideoResource*)msgResource {
     resource = msgResource;
    [SVProgressHUD show];
    if (config == nil) {
        config = [[CloudVideoConfig alloc] init];
        config.delegate = self;
    }
    //下载云视频缩略图
    [config downloadSmallCloudThumb:resource];
    //下载云视频
    [config downloadCloudVideoFile:resource];
}
#pragma mark - 缩略图下载回调
- (void)downloadSmallCloudThumbResult:(int)result path:(NSString *)path {
    if (result < 0) {
        [MessageUI ShowErrorInt:(int)result];
    }else{
        thumbPath = path;
        [tableV reloadData];
    }
}

#pragma mark  - 下载云存储视频开始
- (void)downloadCloudVideoStartResult:(int)result {
    if (result <0) {
        [MessageUI ShowErrorInt:result];
    }else{
    }
}
#pragma mark 下载视频进度
- (void)downloadCloudVideoProgress:(float)progress {
    progres = progress;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = [NSArray arrayWithObject:path];
    [tableV reloadRowsAtIndexPaths:array withRowAnimation:nil];
}
#pragma mark 下载视频完成
- (void)downloadCloudVideoComplete:(int)result path:(NSString*)path {
    [SVProgressHUD dismiss];
    progres = 1;
    videoPath = @"";
    [tableV reloadData];
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (indexPath.row == 0) {
        //云视频时间日期
        cell.textLabel.text = resource.beginDate;
        cell.Labeltext.text = resource.beginTime;
    }else if (indexPath.row == 1) {
        //每一段云视频的缩略图
        if (thumbPath && thumbPath.length >1) {
            NSData *data = [NSData dataWithContentsOfFile:thumbPath];
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }else if (indexPath.row == 2) {
        //云视频下载进度
        cell.textLabel.text = [NSString stringWithFormat:@"Progress: %04f%@",progres*100,@"%"];
    }else if (indexPath.row == 3) {
        //云视频下载路径
        cell.textLabel.text = videoPath;
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
