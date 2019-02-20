//
//  PictureSearchViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/16.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PictureSearchViewController.h"
#import "PictureFileConfig.h"
#import "PictureDownloadViewController.h"
#import "ItemTableviewCell.h"

@interface PictureSearchViewController () <UITableViewDelegate, UITableViewDataSource, PictureFileConfigDelegate>
{
    PictureFileConfig *config;
    UITableView *tableV;
    NSMutableArray *pictureArray;
}
@end

@implementation PictureSearchViewController

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
        config = [[PictureFileConfig alloc] init];
        config.delegate = self;
    }
    //调用按文件查询图片的接口，查询今天的设备图片，可以设置其他想要查询的日期
    [config getDevicePictureByFile:[NSDate date]];
}
#pragma mark 获取摄像机图片代理回调
- (void)getPictureResult:(NSInteger)result {
    if (result >= 0) {
        [SVProgressHUD dismiss];
        pictureArray = [config getPictureFileArray];
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
    PictureInfo *pic = [pictureArray objectAtIndex:indexPath.row];
    cell.textLabel.text = pic.fileName;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击下载图片
    PictureDownloadViewController *downloadVC = [[PictureDownloadViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
    PictureInfo *picInfo = [pictureArray objectAtIndex:indexPath.row];
    [downloadVC startDownloadPicture:picInfo];
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
