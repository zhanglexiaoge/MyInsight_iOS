//
//  ForgetPasswordViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordView.h"
#import "UserAccountModel.h"
#import "NSString+Extention.h"

@interface ForgetPasswordViewController ()<UserAccountModelDelegate>
{
    ForgetPasswordView *forgetPwdView;      //忘记密码视图
    UserAccountModel *accountModel;         //账号相关功能接口管理器
}
@property (nonatomic, strong)NSTimer *myTimer;          //验证计时器
@property (nonatomic, assign)NSInteger continueTime;    //倒计时
@property (nonatomic, assign) BOOL isReceivingCode;     //是否正在接收验证码

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //忘记密码界面视图初始化
    forgetPwdView = [[ForgetPasswordView alloc] init];
    self.view = forgetPwdView;
    
    __weak typeof(self) weakSelf = self;
    //获取验证码事件处理
    forgetPwdView.getCodeBtnClicked = ^(NSString * _Nonnull userPhone) {
        [weakSelf getCodeWithUserPhone:userPhone];
    };
    
    //检查验证码的合法性事件处理
    forgetPwdView.checkCodeBtnClicked = ^(NSString * _Nonnull userPhone, NSString * _Nonnull codeStr) {
        [weakSelf checkCodeWithUserPhone:userPhone codeStr:codeStr];
    };
    
    //重置密码事件处理
    forgetPwdView.resettingPwdBtnClicked = ^(NSString * _Nonnull userPhone, NSString * _Nonnull newPassword) {
        [weakSelf resetPasswordWithUserPhone:userPhone newPassword:newPassword];
    };
    
     //账号相关功能接口管理器
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    
    //设置导航栏
    [self setNaviStyle];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Forget_Pwd");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - button event 按钮点击事件
-(void)popViewController
{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取验证码
-(void)getCodeWithUserPhone:(NSString *)userPhone
{
    //是否正在接收验证码
    if (self.isReceivingCode == NO) {
        
        if (userPhone.length == 0 ) {
            [SVProgressHUD showErrorWithStatus:TS("moblie_error")];
            return;
        }
        
        //判断用户输入的邮箱还是手机号
        if([userPhone containsString:@"@"]){
            //邮箱
            //邮箱注册
            if (![NSString isValidateEmail:userPhone])//邮箱格式判断是否正确
            {
                [SVProgressHUD showErrorWithStatus:TS("error_email_formatter")];
                return;
            }
            
        }else{
            //手机号
            //手机号码长度及格式
            if ([userPhone hasPrefix:@"0"]||userPhone.length != 11) {
                [SVProgressHUD showErrorWithStatus:TS("Number_Format_Error")];
                return;
            }
            
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        //获取验证码
        [accountModel fogetPwdWithPhoneNum:userPhone];
        
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myTimeCount) userInfo:nil repeats:YES];
        self.continueTime = 120;
        self.isReceivingCode = YES;
    }
}

#pragma mark 检查验证码的合法性
-(void)checkCodeWithUserPhone:(NSString *)userPhone codeStr:(NSString *)codeStr
{
    //判断手机码哦或者邮箱是否为空
    if (forgetPwdView.userPhone.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:TS("Empty_Phone_Number")];
        return;
    }
    
    //验证码栏不能为空
    if (forgetPwdView.inputCode.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:TS("input_code")];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //校验验证码
    [accountModel checkCode:userPhone code:codeStr];
    
}

#pragma mark 重置密码
-(void)resetPasswordWithUserPhone:(NSString *)userPhone newPassword:(NSString *)newPassword
{
    //密码字符格式
    BOOL isMatch = [NSString isValidatePassword:newPassword];
    
    //判断密码长度
    if(!isMatch||(newPassword.length < 8||newPassword.length > 32))
    {
        [SVProgressHUD showErrorWithStatus:TS("edit_pwd_error5")];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //重置密码
    [accountModel resetPassword:userPhone newPassword:newPassword];
}

//倒计时处理，刷新时间
-(void)myTimeCount
{
    NSString *myTitle = [NSString stringWithFormat:@"%ld",(long)self.continueTime];
    [forgetPwdView.getCode setTitle:[myTitle stringByAppendingString:TS("resend_Again")] forState:UIControlStateNormal];
    self.continueTime = self.continueTime - 1;
    if (self.continueTime <= 0) {
        [self getCodeBtnResign];
    }
}

//重置计时器
-(void)getCodeBtnResign
{
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
    [forgetPwdView.getCode setTitle:TS("get_code") forState:UIControlStateNormal];
    self.isReceivingCode = NO;
}

#pragma mark - funsdk 回调处理
//获取验证码回调
-(void)forgetPwdGetCodeDelegateResult:(long)reslut userName:(NSString *)name
{
    [SVProgressHUD dismiss];
    if (reslut >= 0) {
        forgetPwdView.userNameLabel.text = [NSString stringWithFormat:@"%@%@",TS("forget_username_is"),name];
    }
    else{
        [MessageUI ShowErrorInt:(int)reslut];
        [self getCodeBtnResign];
    }
}

//检查验证码的合法性回调
-(void)checkCodeDelegateResult:(long)reslut
{
    [SVProgressHUD dismiss];
    if (reslut >= 0) {
        forgetPwdView.checkBtn.hidden = YES;
        forgetPwdView.confirmPwdView.hidden = NO;
    }
    else{
         [MessageUI ShowErrorInt:(int)reslut];
        
    }
}

//重置密码回调
-(void)resetPasswordDelegateResult:(long)reslut
{
    [SVProgressHUD dismiss];
    if (reslut >= 0) {
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
    }
    else{
         [MessageUI ShowErrorInt:(int)reslut];
    }
}

@end
