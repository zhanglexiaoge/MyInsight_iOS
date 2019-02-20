//
//  MainViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/16.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceListViewController.h"
#import "AccountViewController.h"
#import "DeviceAddViewController.h"
#import "PhotosViewController.h"
#import "UserAccountModel.h"

#import "LoginViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UserAccountModel *accountModel;
    NSMutableArray *titleArray;
}
//登录状态按钮,如果未登录点击进入登录界面
@property (nonatomic, strong) UIBarButtonItem *loginBtn;
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setNaviStyle];
    [self initData];
    //判断用户登录类型,如果非自动登录需要跳转到登录界面
    if ([LoginShowControl getAutoLoginType] == NO) {
        [self presentToLoginVC];
    }
    //配置子试图
    [self configSubView];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("FunSDKDemo");
    [self.navigationController.navigationBar setBarTintColor:GlobalMainColor];
    self.loginBtn = [[UIBarButtonItem alloc] initWithTitle:TS("Logout") style:UIBarButtonItemStyleDone target:self action:@selector(loginOpration)];
    self.navigationItem.rightBarButtonItem = self.loginBtn;
    self.loginBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)initData {
    accountModel = [[UserAccountModel alloc] init];
    titleArray = (NSMutableArray*)@[TS("About_User"),TS("About_Device"),TS("DeviceList"),
                                    TS("photos"),TS("About_Demo")];
}
- (void)configSubView {
    [self.view addSubview:self.mainTableView];
}

#pragma mark -- UITableViewDelegate/dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [titleArray objectAtIndex:indexPath.section];
    if ([title isEqualToString:TS("About_User")]) {
        //用户信息视图控制器，包括注册，登录，找回密码，修改密码等等
        AccountViewController *accountVC = [[AccountViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:accountVC animated:YES];
    }
    if ([title isEqualToString:TS("About_Device")]) {
        //如果是直连状态，不支持添加设备
        if ([[LoginShowControl getInstance] getLoginType] == loginTypeAP) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("Error_Prompt") message:TS("not_support_add_device") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        //添加设备控制器，包括序列号添加设备、IP域名添加设备、Wi-Fi快速配置添加设备、局域网搜索添加设备等
        DeviceAddViewController *deviceAddVC = [[DeviceAddViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:deviceAddVC animated:YES];
    }
    if ([title isEqualToString:TS("DeviceList")]) {
        //设备列表控制器
        DeviceListViewController *devicelistVC = [[DeviceListViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:devicelistVC animated:YES];
    }
    if ([title isEqualToString:TS("photos")]) {
        //本地相册控制器
        PhotosViewController *photosVC = [[PhotosViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:photosVC animated:YES];
    }
    if ([title isEqualToString:TS("About_Demo")]) {
        
    }
}

#pragma mark -- 未登录或者登出按钮点击
- (void)loginOpration {
    //跳转到登陆界面
    //Jump to the login interface
    if ([[LoginShowControl getInstance] getLoginType] != loginTypeNone) {
        [accountModel loginOut];
        [[LoginShowControl getInstance] setLoginType:loginTypeNone];
    }
    [self presentToLoginVC];
}

- (void)presentToLoginVC {
    LoginViewController *loginV = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
       [self.navigationController pushViewController:loginV animated:YES];
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainCell"];
        _mainTableView.tableFooterView = [UIView new];
    }
    return _mainTableView;
}
@end
