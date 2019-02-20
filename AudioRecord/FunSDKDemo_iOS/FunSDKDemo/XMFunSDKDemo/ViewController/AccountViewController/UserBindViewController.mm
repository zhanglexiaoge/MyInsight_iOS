//
//  UserBindViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/2.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "UserBindViewController.h"
#import "UserBindView.h"
#import "UserAccountModel.h"
#import "NSString+Extention.h"

@interface UserBindViewController ()<UserAccountModelDelegate>
{
    UserBindView *userBindView;         // 用户手机号/邮箱绑定视图
    UserAccountModel *accountModel;     //账号相关功能接口管理器
    NSInteger sendTime;                 //倒计时时间
    NSTimer *countDownTimer;            //倒计时计时器
    BOOL isReceivingCode;               //是否正在接收验证码
}


@end

@implementation UserBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //账号相关功能接口管理器
    accountModel = [[UserAccountModel alloc] init];
    accountModel.delegate = self;
    
    // 用户手机号/邮箱绑定视图初始化
    userBindView = [[UserBindView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    // 获取验证码事件处理（绑定手机或邮箱）
    userBindView.getCodeBtnClicked = ^(NSString * _Nonnull phoneEmail) {
        [weakSelf getCodeBtnClickedWithPhoneEmail:phoneEmail];
    };
    
    //绑定手机或者邮箱
    userBindView.bindBtnClicked = ^(NSString * _Nonnull phoneEmail, NSString * _Nonnull code) {
        [weakSelf bindBtnClickedWithPhoneEmail:phoneEmail code:code];
    };
    
    self.view = userBindView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNav];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // 判断当前需要绑定的是否为手机号，是的话更新界面
    if ([self.navigationItem.title isEqualToString:TS("bind_phoneNumber")]) {
        [userBindView.bindBtn setTitle:TS("bind_phoneNumber") forState:UIControlStateNormal];
        userBindView.phoneEmailTF.placeholder = TS("enter_phoneNum");
    }
}

#pragma mark - 设置导航栏
-(void)configNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark - EventAction
-(void)backItemClicked
{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取验证码
-(void)getCodeBtnClickedWithPhoneEmail:(NSString *)phoneEmail
{
     if (isReceivingCode == NO) {
         //手机号码或者邮箱不得为空
         if (phoneEmail.length == 0) {
             [SVProgressHUD showErrorWithStatus:TS("moblie_error")];
             return;
         }
         //判断用户输入的邮箱还是手机号
         if([phoneEmail containsString:@"@"]) {
             //邮箱
             if (![NSString isValidateEmail:phoneEmail])//邮箱格式判断是否正确
             {
                 [SVProgressHUD showErrorWithStatus:TS("PhoneOrEmailError")];
                 return;
             }
         }
         else{
             //手机号
             if (phoneEmail.length != 11) {
                 [SVProgressHUD showErrorWithStatus:TS("PhoneOrEmailError")];;
                 return;
             }
         }
         [SVProgressHUD show];
         
         //开始倒计时
         sendTime = 120;
         isReceivingCode = YES;
         countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownFunction) userInfo:nil repeats:YES];
         
         NSString *useName = [[LoginShowControl getInstance] getLoginUserName];
         NSString *passWord = [[LoginShowControl getInstance] getLoginPassword];
         
         //发送获取验证码命令
         [accountModel getBindingPhoneEmailCode:useName password:passWord PhoneOrEmail:phoneEmail];
     }
}

#pragma mark 发送绑定手机号或邮箱命令
-(void)bindBtnClickedWithPhoneEmail:(NSString *)phoneEmail code:(NSString *)code
{
    if (phoneEmail.length == 0) {
        [SVProgressHUD showErrorWithStatus:TS("moblie_error")];
        return;
    }
    //判断用户输入的邮箱还是手机号
    if([phoneEmail containsString:@"@"]) {
        //邮箱
        if (![NSString isValidateEmail:phoneEmail])//邮箱格式判断是否正确
        {
            [SVProgressHUD showErrorWithStatus:TS("PhoneOrEmailError")];
            return;
        }
    }
    else{
        //手机号
        if (phoneEmail.length != 11) {
            [SVProgressHUD showErrorWithStatus:TS("PhoneOrEmailError")];;
            return;
        }
    }
    
    if (code.length == 0) {
      
        [SVProgressHUD showErrorWithStatus:TS("input_code")];
        return;
    }
    
    [SVProgressHUD show];
    
    
    NSString *useName = [[LoginShowControl getInstance] getLoginUserName];
    NSString *passWord = [[LoginShowControl getInstance] getLoginPassword];
    
    //发送绑定手机号或邮箱命令
    [accountModel bindPhoneEmail:useName password:passWord PhoneOrEmail:phoneEmail code:code];
    
}

//获取验证码倒计时处理
-(void)countDownFunction
{
    if(sendTime > 0) {//刷新倒计时时间
        NSString *getCodeBtnTitle = [NSString  stringWithFormat:@"%d%@%@",(int)sendTime,TS("general_second"),TS("ReGetRegCode")];
        [userBindView.getCodeBtn setTitle:getCodeBtnTitle forState:UIControlStateNormal];
        sendTime--;
    }else{
       [self getCodeBtnResign];
    }
}

//重置计时器
-(void)getCodeBtnResign
{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [userBindView.getCodeBtn setTitle:TS("get_code") forState:UIControlStateNormal];
    isReceivingCode = NO;
}

#pragma mark - funsdk回调处理
#pragma mark 获取验证码回调（绑定邮箱/手机）
-(void)getCodeForBindPhoneEmailResult:(long)result
{
    [SVProgressHUD dismiss];
    if (result >= 0) {
        //倒计时开始

    }
    else{
       [MessageUI ShowErrorInt:(int)result];
        [self getCodeBtnResign];
    }
}

#pragma mark 绑定邮箱/手机回调
-(void)bindPhoneEmailResult:(long)result
{
    [SVProgressHUD dismiss];
    if (result >= 0) {
        [SVProgressHUD showErrorWithStatus:TS("Success")];
        if (self.bindPhoneEmailSuccess) {
            self.bindPhoneEmailSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

@end
