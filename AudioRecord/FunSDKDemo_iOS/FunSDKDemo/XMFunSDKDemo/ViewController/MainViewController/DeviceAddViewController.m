//
//  DeviceAddViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/29.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "DeviceAddViewController.h"
#import "SerialNumAddViewController.h"
#import "IPAddViewController.h"
#import "LANSearchViewController.h"
#import "QuickConfigurationViewController.h"

@interface DeviceAddViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *titleArray;
    UITableView *mainTableView;
}


@end
@implementation DeviceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setNaviStyle];
    [self initData];
    //配置子试图
    [self configSubView];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("About_Device");
}

- (void)initData {
    titleArray =  (NSMutableArray*)@[TS("Connect_DevMac"),TS("add_by_ip/domain"),TS("Connect_localNetwork"),TS("Connect_WiFi")];
}
- (void)configSubView {
    [self.view addSubview:self.mainTableView];
}

#pragma mark -- UITableViewDelegate/dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    if ([title isEqualToString:TS("Connect_DevMac")]) {
        //序列号添加设备
        SerialNumAddViewController *addVC = [[SerialNumAddViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    if ([title isEqualToString:TS("add_by_ip/domain")]) {
        //ip/域名添加设备
        IPAddViewController *addVC = [[IPAddViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    if ([title isEqualToString:TS("Connect_localNetwork")]) {
        //局域网添加设备
        LANSearchViewController *searchVC = [[LANSearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    if ([title isEqualToString:TS("Connect_WiFi")]) {
        //快速配置
        QuickConfigurationViewController *configVC = [[QuickConfigurationViewController alloc] init];
        [self.navigationController pushViewController:configVC animated:YES];
    }
}
- (UITableView *)mainTableView {
    if (!mainTableView) {
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ScreenHeight) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainCell"];
    }
    return mainTableView;
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
