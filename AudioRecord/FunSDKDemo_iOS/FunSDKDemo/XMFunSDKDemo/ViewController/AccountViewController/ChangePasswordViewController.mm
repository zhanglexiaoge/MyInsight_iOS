//
//  ChangePasswordViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordView.h"
#import "UserAccountModel.h"
#import "NSString+Extention.h"

@interface ChangePasswordViewController ()<UserAccountModelDelegate>
{
    ChangePasswordView *changePwdView;   //修改账号密码视图
    UserAccountModel *accountModel;      //账号相关功能接口管理器
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //账号相关功能接口管理器
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    
    //修改账号密码视图初始化
    changePwdView = [[ChangePasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    __weak typeof(self) weakSelf = self;
    //修改密码按钮点击处理
    changePwdView.changePwdBtnClicked = ^(NSString * _Nonnull userName,NSString * _Nonnull pwdOld, NSString * _Nonnull pwdNew1, NSString * _Nonnull pwdNew2) {
        [weakSelf changePassWordWithUserName:userName OldPwd:pwdOld newPwd:pwdNew1 confirmPwd:pwdNew2];
    };
    
    self.view = changePwdView;
    
    //设置导航栏
    [self setNaviStyle];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Modify_pwd");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - button event
-(void)popViewController
{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 修改密码按钮点击处理
-(void)changePassWordWithUserName:(NSString *)userName OldPwd:(NSString *)pwdOld newPwd:(NSString *)pwdNew1 confirmPwd:(NSString *)pwdNew2
{
    //判断原密码是否为空
    if (pwdOld.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:TS("password_error2")];
        return;
    }
     //判断新密码是否为空
    if (pwdNew1.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:TS("set_new_psd")];
        return;
    }
    
    //检查新密码格式
    if(![NSString isValidatePassword:pwdNew1]){
        [SVProgressHUD showErrorWithStatus:TS("edit_pwd_error5")];
        return;
    }
    
    //判断2次新密码是否相同
    if ( ![pwdNew1 isEqualToString:pwdNew2]) {
        [SVProgressHUD showErrorWithStatus:TS("pass_notsame")];
        return;
    }
    
    [SVProgressHUD show];
    //发送修改密码命令
    [accountModel changePassword:userName oldPassword:pwdOld newPsw:pwdNew1];
}

#pragma mark - funsdk 回调处理
-(void)changePasswordDelegateResult:(long)result
{
    [SVProgressHUD dismiss];
    if (result >= 0) {
        [SVProgressHUD showSuccessWithStatus:TS("Modify_pwd_success")];
    }
    else{
        [MessageUI ShowErrorInt:(int)result title:TS("Modify_pwd_failed")];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
