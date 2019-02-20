//
//  RegisterViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "UserAccountModel.h"
#import "PrivacyPolicyVC.h"
#import "NSString+Extention.h"

@interface RegisterViewController ()<UserAccountModelDelegate>
{
    UserAccountModel *accountModel; //账号相关功能接口管理器
    RegisterView *registerView;     //注册视图
    NSInteger sendTime;             //倒计时时间
    NSTimer *countDownTimer;        //倒计时计时器
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //账号相关功能接口管理器
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    //初始化注册视图
    registerView = [[RegisterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    __weak typeof(self) weakSelf = self;
    //注册按钮点击事件处理
    registerView.registerBtnClicked = ^(NSString * _Nonnull userName, NSString * _Nonnull password1, NSString * _Nonnull password2, NSString * _Nonnull phoneStr, NSString * _Nonnull codeStr) {
        [weakSelf registerUserName:userName password1:password1 password2:password2 code:codeStr PhoneOrEmail:phoneStr];
    };
    
    //获取验证码点击事件处理
    registerView.getCodeBtnClicked = ^(NSString * _Nonnull phoneStr) {
        [weakSelf getCodeWithPhoneOrEmail:phoneStr];
    };
    
    //查看隐私政策事件处理
    registerView.btnPrivacyBtnClicked = ^{
        [weakSelf btnPrivacyBtnClicked];
    };
    
    self.view = registerView;
    
    //设置导航栏
    [self setNaviStyle];
    
}

//设置导航栏
- (void)setNaviStyle {
    self.navigationItem.title = TS("Register_User");
    
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

#pragma mark 隐私政策按钮点击
-(void)btnPrivacyBtnClicked
{
    PrivacyPolicyVC *privacyVC = [[PrivacyPolicyVC alloc] init];
    [self.navigationController pushViewController:privacyVC animated:YES];
}

#pragma mark 注册按钮点击
-(void)registerUserName:(NSString *)username password1:(NSString *)password1 password2:(NSString *)password2 code:(NSString *)code PhoneOrEmail:(NSString *)phoneEmail
{
    registerView.errorTipLabel.text = @"";
    //判断是否为空
    if (username.length == 0||password1.length == 0||password2.length == 0) {
        registerView.errorTipLabel.text = TS("fill_Info");
        return;
    }
    //检测用户名是否合法
    if(![NSString isValidateUserName:username]){
        registerView.errorTipLabel.text = TS("illegal_username");
        return;
    }
    
    //密码两个密码是否相等
    if (![password1 isEqualToString:password2]) {
        registerView.errorTipLabel.text = TS("pass_notsame");
        return;
    }
    //检查密码格式
    if(![NSString isValidatePassword:password1]){
        registerView.errorTipLabel.text = TS("edit_pwd_error5");
        return;
    }
    if (registerView.jumpBtn.selected) { //跳过验证码注册
        [accountModel registerUserName:username password:password1 code:@"" PhoneOrEmail:@""];
    }else{
        //判断手机号和验证码是否为空
        if (phoneEmail.length == 0||code.length == 0) {
            registerView.errorTipLabel.text = TS("fill_Info");
            return;
        }
        //通过手机号或者邮箱注册
        [accountModel registerUserName:username password:password1 code:code PhoneOrEmail:phoneEmail];
    }
    [SVProgressHUD show];
}

#pragma mark 获取验证码
-(void)getCodeWithPhoneOrEmail:(NSString *)phoneStr
{
    registerView.errorTipLabel.text = @"";
    //手机号码或者邮箱不得为空
    if (registerView.phoneTF.text.length == 0) {
        registerView.errorTipLabel.text = TS("moblie_error");
        return;
    }
    //判断用户输入的邮箱还是手机号
    if([registerView.phoneTF.text containsString:@"@"]) {
        //邮箱注册
        if (![NSString isValidateEmail:registerView.phoneTF.text])//邮箱格式判断是否正确
        {
            registerView.errorTipLabel.text = TS("PhoneOrEmailError");
            return;
        }
        
        //获取验证码
        [accountModel getCodeWithPhoneOrEmailNumber:phoneStr];
    }
    else{
        //手机号注册，手机号初步判断是否有效
        if (registerView.phoneTF.text.length != 11) {
            registerView.errorTipLabel.text = TS("PhoneOrEmailError");
            return;
        }
        //获取验证码
        [accountModel getCodeWithPhoneOrEmailNumber:phoneStr];
    }
    [SVProgressHUD show];

}

//获取验证码倒计时处理
-(void)countDownFunction
{
    if(sendTime > 0) {//刷新倒计时时间
        NSString *getCodeBtnTitle = [NSString  stringWithFormat:@"%d%@",(int)sendTime,TS("general_second")];
        [registerView.getCodeBtn setTitle:getCodeBtnTitle forState:UIControlStateNormal];
        sendTime--;
        registerView.jumpBtn.hidden = YES;
    }else{
        [registerView.getCodeBtn setTitle:TS("ReGetRegCode") forState:UIControlStateNormal];
        registerView.getCodeBtn.enabled = YES;
        
        //倒计时结束,手机号输入框显示
        registerView.phoneTF.hidden = NO;
        registerView.codeTF.hidden = YES;
        //定时器暂停
        [countDownTimer setFireDate:[NSDate distantFuture]];
        //倒计时结束且验证码栏未填,显示跳过按钮
        if (registerView.codeTF.text.length == 0) {
            registerView.jumpBtn.hidden = NO;
        }
    }
    
}

#pragma mark - funsdk 回调处理
// 获取验证码回调
- (void)getCodeDelegateResult:(long)reslut
{
    [SVProgressHUD dismiss];
    if (reslut >= 0) {
        registerView.phoneTF.hidden = YES;
        registerView.codeTF.hidden = NO;
        //获取验证码按钮变为倒计时
        sendTime = 120;
        registerView.getCodeBtn.enabled = NO;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownFunction) userInfo:nil repeats:YES];
    }else{
        if(reslut != EE_AS_PHONE_CODE2 && reslut!= EE_AS_REGISTE_BY_EMAIL_CODE5){
            registerView.jumpBtn.hidden = NO;
            [SVProgressHUD showSuccessWithStatus:TS("EE_AS_SYS_GET_USER_INFO_CODE4")];
        }
      
    }
}

//用户注册回调
-(void)registerUserNameDelegateResult:(long)reslut
{
    [SVProgressHUD dismiss];
    if (reslut >= 0) {
        [SVProgressHUD showSuccessWithStatus:TS("Register_Success")];
    }
    else{
          registerView.errorTipLabel.text = TS("register_failure");
    }
}

@end
