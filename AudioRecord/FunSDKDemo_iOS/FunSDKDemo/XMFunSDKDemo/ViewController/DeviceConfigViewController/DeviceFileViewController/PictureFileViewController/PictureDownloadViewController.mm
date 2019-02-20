//
//  PictureDownloadViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PictureDownloadViewController.h"
#import "PictureFileDownloadConfig.h"
#import "ItemTableviewCell.h"


@interface PictureDownloadViewController () <UITableViewDelegate,UITableViewDataSource,PictureDownloadDelegate>
{
    PictureFileDownloadConfig *config;
    UITableView *tableV;
    PictureInfo *picInfo;
    NSString *thumbPath;
    NSString *picPath;
    float progres;
}
@end

@implementation PictureDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubView];
}

#pragma mark - 开始下载设备图片
- (void)startDownloadPicture:(PictureInfo*)pictureInfo {
    picInfo = pictureInfo;
    if (config == nil) {
        config = [[PictureFileDownloadConfig alloc] init];
        config.delegate = self;
    }
    //下载小缩略图
    [config downloadSmallPicture:picInfo];
    //下载原图
    [config downloadPicture:picInfo];
}
#pragma mark - 缩略图下载回调
- (void)thumbDownloadResult:(NSInteger)result path:(NSString*)thumbPaths {
    if (result < 0) {
        [MessageUI ShowErrorInt:(int)result];
    }else{
        [SVProgressHUD dismiss];
        thumbPath = thumbPaths;
        [tableV reloadData];
    }
}
#pragma mark -下载原图片开始回调
- (void)pictureDownloadStartResult:(NSInteger)result {
    if (result <0) {
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark -下载进度回调
- (void)pictureDownloadProgressResult:(float)progress {
    progres = progress;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = [NSArray arrayWithObject:path];
    [tableV reloadRowsAtIndexPaths:array withRowAnimation:nil];
}
#pragma mark -下载原图片完成回调
- (void)pictureDownloadEndResultPath:(NSString*)path {
    progres = 1;
    picPath = path;
    [tableV reloadData];
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 300;
    }
    return 60;
}
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
        cell.textLabel.text = picInfo.fileName;
    }else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"fileSize：%ldK",picInfo.fileSize];
        if (thumbPath && thumbPath.length >1) {
            NSData *data = [NSData dataWithContentsOfFile:thumbPath];
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"DownloadProgress: %04f%@",progres*100,@"%"];
    }else if (indexPath.row == 3) {
        if (picPath && picPath.length >1) {
            NSData *data = [NSData dataWithContentsOfFile:picPath];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 300, 300)];
            imageV.image = [UIImage imageWithData:data];
            [cell addSubview:imageV];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.title = TS("picture_download");
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
