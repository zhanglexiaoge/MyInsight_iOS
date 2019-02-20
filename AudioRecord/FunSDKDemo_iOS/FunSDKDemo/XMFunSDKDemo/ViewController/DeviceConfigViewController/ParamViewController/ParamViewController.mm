//
//  ParamViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/9.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ParamViewController.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
#import "VideoRotainConfig.h"

@interface ParamViewController () <UITableViewDelegate,UITableViewDataSource,VideoRotainConfigDelegate>
{
    VideoRotainConfig *config; //摄像机参数配置 （图像翻转等等）
    UITableView *paramTableView;
    NSMutableArray *paramTitleArray;
}
@end

@implementation ParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    // 获取摄像机参数配置
    [self getVideoRotainConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取摄像机参数配置
- (void)getVideoRotainConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[VideoRotainConfig alloc] init];
        config.delegate = self;
    }
    //调用获取摄像机图像翻转等参数的接口
    [config getRotainConfig];
}
#pragma mark 获取摄像机参数代理回调
- (void)getVideoRotainConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.paramTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - 保存摄像机参数配置 （图像翻转）
-(void)saveConfig{
    [SVProgressHUD show];
    [config setRotainConfig];
}
#pragma mark 保存摄像机参数代理回调
- (void)setVideoRotainConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return paramTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [paramTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if ([config checkParam] == NO) {
        //当前配置参数无效，不能刷新
        return cell;
    }
    if ([title isEqualToString:TS("Flip_Vertical")]) {
        cell.Labeltext.text =  [config getPictureFlip];
    }else if ([title isEqualToString:TS("Flip_Horizontal")]) {
        cell.Labeltext.text =[config getPictureMirror];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([config checkParam] == NO) {
        return; //图像翻转数据异常，无法进行配置
    }
    NSString *titleStr = paramTitleArray[indexPath.row];
    //初始化各个配置的item单元格
    ItemViewController *itemVC = [[ItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.paramTableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
        if ([cell.textLabel.text isEqualToString:TS("Flip_Vertical")]) {
            [config setPictureFlip:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("Flip_Horizontal")]){
            [config setPictureMirror:encodeString];
        }else{
            return;
        }
    };
    //点击单元格之后进行分别赋值
    if ([titleStr isEqualToString:TS("Flip_Vertical")]) {
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("Flip_Horizontal")]){
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else{
        return;
    }
    //如果赋值成功，跳转到下一级界面
    [self.navigationController pushViewController:itemVC animated:YES];
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.paramTableView];
}
- (UITableView *)paramTableView {
    if (!paramTableView) {
        paramTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        paramTableView.delegate = self;
        paramTableView.dataSource = self;
        [paramTableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return paramTableView;
}
#pragma mark - 界面和数据初始化
- (void)initDataSource {
    paramTitleArray = (NSMutableArray*)@[TS("Flip_Vertical"),TS("Flip_Horizontal")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
