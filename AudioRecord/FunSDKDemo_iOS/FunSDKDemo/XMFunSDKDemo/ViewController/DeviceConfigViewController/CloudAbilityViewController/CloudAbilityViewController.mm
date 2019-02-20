//
//  CloudAbilityViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/12/27.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "CloudAbilityViewController.h"
#import "CloudServerViewController.h"
#import "PlayCloudVideoViewController.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
#import "CloudAbilityConfig.h"

@interface CloudAbilityViewController () <UITableViewDelegate,UITableViewDataSource,CloudStateRequestDelegate>
{
        UITableView *itemTableView;
        NSMutableArray *titleArray;
}
@property (nonatomic, strong) CloudAbilityConfig * cloudConfig;
@end

@implementation CloudAbilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    // 获取智能分析配置
    [self getCloudAbility];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取智能分析配置
- (void)getCloudAbility {
    [SVProgressHUD showWithStatus:TS("")];
    if (_cloudConfig == nil) {
        _cloudConfig = [[CloudAbilityConfig alloc] init];
        _cloudConfig.delegate = self;
    }
    //调用获取云服务状态的接口
    [_cloudConfig getCloudAbilityServer];
    //获取云视频和云图片的状态
    [_cloudConfig getVideoOrPicAbilityServer];
}

#pragma mark 获取云服务能力级回调
- (void)getCloudAbilityResult:(NSInteger)result {
    if (result >=0) {
        //成功，刷新界面数据
        [self.itemTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}
 #pragma mark 获取云视频和云图片能力级回调
-(void)getVideoOrPicAbilityResult:(NSInteger)result {
    if (result >=0) {
        //成功，刷新界面数据
        [self.itemTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark 获取智能分析代理回调
- (void)getAnalyzeConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.itemTableView reloadData];
        [SVProgressHUD dismiss];
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
    if ([title isEqualToString:TS("Cloud_storage")]) {
        cell.Labeltext.text =  [_cloudConfig getCloudState];
    }
    if ([title isEqualToString:TS("search_Video")]) {
        cell.Labeltext.text = [_cloudConfig getVideoEnable];
    }
    if ([title isEqualToString:TS("search_picture")]) {
        cell.Labeltext.text =  [_cloudConfig getPicEnable];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    //点击单元格之后进行分别赋值
    if ([titleStr isEqualToString:TS("Cloud_storage")]) {
       //云服务
        if ([[_cloudConfig getCloudState] isEqualToString:TS("not_suport")]) {
            return;   //不支持，直接return
        }else{
            //跳入云服务页面
            CloudServerViewController *cloudServerVC = [[CloudServerViewController alloc] init];
            [self.navigationController pushViewController:cloudServerVC animated:YES];
        }
    }else if ([titleStr isEqualToString:TS("search_Video")]) {
       //云视频
        if ([[_cloudConfig getVideoEnable] isEqualToString:TS("not_opened")]) {
            return;
        }else {
            CloudVideoViewController *cloudVideoVC = [[CloudVideoViewController alloc] init];
             [self.navigationController pushViewController:cloudVideoVC animated:YES];
        }
    }else if ([titleStr isEqualToString:TS("search_picture")]) {
        //云图片
        if ([[_cloudConfig getVideoEnable] isEqualToString:TS("not_opened")]) {
            return;
        }else {
            CloudPhotoViewController *cloudPhotoVC = [[CloudPhotoViewController alloc] init];
            [self.navigationController pushViewController:cloudPhotoVC animated:YES];
        }
    }else if ([titleStr isEqualToString:TS("Cloud_video")]) {
        //云视频播放
        PlayCloudVideoViewController *playCloudVC = [[PlayCloudVideoViewController alloc] init];
        [self.navigationController pushViewController:playCloudVC animated:YES];
    }else{
        return;
    }
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    self.navigationItem.title = TS("Cloud_storage");
    [self.view addSubview:self.itemTableView];
}
- (UITableView *)itemTableView {
    if (!itemTableView) {
        itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        itemTableView.delegate = self;
        itemTableView.dataSource = self;
        [itemTableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return itemTableView;
}
#pragma mark - 界面和数据初始化
- (void)initDataSource {
    titleArray = (NSMutableArray*)@[TS("Cloud_storage"),TS("search_Video"),TS("search_picture"),TS("Cloud_video")];
}
@end
