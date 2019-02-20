//
//  VideoFileViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/13.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "VideoFileViewController.h"
#import "ByFileViewController.h"
#import "ByTimeViewController.h"
#import "MonthFileViewController.h"
#import "ItemTableviewCell.h"

@interface VideoFileViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableV;
    NSMutableArray *titleArray;
}
@end

@implementation VideoFileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    if ([titleStr isEqualToString:TS("search_by_file")]) {
        ByFileViewController *byFileVC = [[ByFileViewController alloc] init];
        [self.navigationController pushViewController:byFileVC animated:YES];
    }else if ([titleStr isEqualToString:TS("search_by_time")]) {
        ByTimeViewController *byTimeVC = [[ByTimeViewController alloc] init];
        [self.navigationController pushViewController:byTimeVC animated:YES];
    }else if ([titleStr isEqualToString:TS("search_video_date")]) {
        MonthFileViewController *monthFileVC = [[MonthFileViewController alloc] init];
        [self.navigationController pushViewController:monthFileVC animated:YES];
    }
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
    titleArray = (NSMutableArray*)@[TS("search_by_file"),TS("search_by_time"),TS("search_video_date")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
