//
//  UserInfoViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/1.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserAccountModel.h"
#import "UserInfoView.h"
#import "UserBindViewController.h"

@interface UserInfoViewController ()<UserAccountModelDelegate>
{
    UserAccountModel *accountModel; //账号相关功能接口管理器
    UserInfoView *userInfoView;     //用户信息视图
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //用户信息视图初始化
    userInfoView = [[UserInfoView alloc] init];
    __weak typeof(self) weakSelf = self;
    
    //跳转绑定手机号或邮箱界面事件处理
    userInfoView.clickBindAccount = ^(NSString * _Nonnull titleStr) {
        [weakSelf clickToBindAccount:titleStr];
    };
    
    self.view = userInfoView;
    
    //设置导航栏
    [self setNaviStyle];
    
    //账号相关功能接口管理器
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    
    //获取用户信息
    [accountModel requestAccountInfo];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Info_User");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - button event 按钮点击事件
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 跳转绑定手机号或邮箱界面
-(void)clickToBindAccount:(NSString *)title
{
    UserBindViewController *bindVC = [[UserBindViewController alloc] init];
    //绑定成功，重新获取用户信息
    bindVC.bindPhoneEmailSuccess = ^{
        [accountModel requestAccountInfo];
    };
    bindVC.navigationItem.title = title;
    
    [self.navigationController pushViewController:bindVC animated:YES];
}

#pragma mark - Funsdk 回调处理
-(void)getUserInfo:(NSMutableDictionary *)userInfoDic result:(int)result
{
    [SVProgressHUD dismiss];
    if (result >= 0) {
        if (userInfoDic != nil) {
            NSMutableDictionary *dataDic = [userInfoDic objectForKey:@"data"];
            userInfoView.infoDic = [dataDic mutableCopy];
            [userInfoView.tbUserInfo reloadData];
        }

    }
    else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

@end
