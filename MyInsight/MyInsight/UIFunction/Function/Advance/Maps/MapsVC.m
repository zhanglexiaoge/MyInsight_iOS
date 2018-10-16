//
//  MapsVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MapsVC.h"
#import "BaiduMapVC.h"
#import "SystemMapVC.h"
#import "GoogleMapVC.h"
#import "YahooMapVC.h"
#import "GaodeMapVC.h"

@interface MapsVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数据数组
@property (nonatomic, strong) NSArray *dataArray;

@end

// 定义字符串
static const NSString *BaiduMapStr = @"百度地图";
static const NSString *SystemMapStr = @"系统(高德)地图";
static const NSString *GoogleMapStr = @"谷歌地图";
static const NSString *YahooMapStr = @"雅虎地图YahooMap";
static const NSString *GaodeMapStr = @"高德地图";

@implementation MapsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    
    [self handleTableViewData];
    
    [self creatTableView];
}

// 处理数据
- (void)handleTableViewData {
    // 初始化数组
    self.dataArray = [NSMutableArray arrayWithArray:@[BaiduMapStr, SystemMapStr, GoogleMapStr, YahooMapStr, GaodeMapStr]];
}

#pragma mark - 创建TableView
- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    // 设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 清空多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - 实现TableView的代理协议
// section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// section中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"MineCell" owner:self options:nil] lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:BaiduMapStr]) {
        // 百度地图 BaiDu
        BaiduMapVC *baiduMapVC = [[BaiduMapVC alloc] init];
        baiduMapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baiduMapVC animated:YES];
    }
    if ([cellString isEqual:SystemMapStr]) {
        // 系统地图 国内为高德地图 国外为谷歌地图
        SystemMapVC *systemMapVC = [[SystemMapVC alloc] init];
        systemMapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemMapVC animated:YES];
    }
    if ([cellString isEqual:GoogleMapStr]) {
        // 谷歌地图Google
        GoogleMapVC *googleMapVC = [[GoogleMapVC alloc] init];
        googleMapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:googleMapVC animated:YES];
    }
    if ([cellString isEqual:YahooMapStr]) {
        // 雅虎地图Yahoo
        YahooMapVC *yahooMapVC = [[YahooMapVC alloc] init];
        yahooMapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:yahooMapVC animated:YES];
    }
    if ([cellString isEqual:GaodeMapStr]) {
        // 高德地图
        GaodeMapVC *gaodeMapVC = [[GaodeMapVC alloc] init];
        gaodeMapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gaodeMapVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
