//
//  TouchIDVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/31.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "TouchIDVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Masonry.h>
#import "UIColor+Category.h"

@interface TouchIDVC ()
//
@property (nonatomic, strong) UIButton *touchIDButton;

@property (nonatomic, strong) UIButton *passwordButton;

@end

@implementation TouchIDVC

// 指纹识别
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"指纹识别&密码输入";
    
    [self creatContentView];
    
    [self masonryLayout];
}

- (void)creatContentView {
    self.touchIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.touchIDButton];
    [self.touchIDButton setTitle:@"TouchID验证" forState:UIControlStateNormal];
    self.touchIDButton.backgroundColor = [UIColor RandomColor];
    [self.touchIDButton addTarget:self action:@selector(touchIDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.passwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.passwordButton];
    [self.passwordButton setTitle:@"密码验证" forState:UIControlStateNormal];
    self.passwordButton.backgroundColor = [UIColor RandomColor];
    [self.passwordButton addTarget:self action:@selector(passwordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchIDButtonAction:(UIButton *)button {
    //创建LAContext
    LAContext *context = [LAContext new];
    
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"没有忘记密码";
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"验证成功 刷新主界面");
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"用户取消验证Touch ID");
                        break;
                    case LAErrorAuthenticationFailed:
                        NSLog(@"授权失败");
                        break;
                    case LAErrorPasscodeNotSet:
                        NSLog(@"系统未设置密码");
                        break;
                    case LAErrorTouchIDNotAvailable:
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    case LAErrorUserFallback: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"TouchID is not enrolled");
                break;
            case LAErrorPasscodeNotSet:
                NSLog(@"A passcode has not been set");
                break;
            default:
                NSLog(@"TouchID not available");
                break;
        }
        NSLog(@"%@",error.localizedDescription);
    }
}

- (void)passwordButtonAction:(UIButton *)button {
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        //系统取消授权，如其他APP切入
                        break;
                    case LAErrorUserCancel:
                        //用户取消验证Touch ID
                        break;
                    case LAErrorAuthenticationFailed:
                        //授权失败
                        break;
                    case LAErrorPasscodeNotSet:
                        //系统未设置密码
                        break;
                    case LAErrorTouchIDNotAvailable:
                        //设备Touch ID不可用，例如未打开
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        //设备Touch ID不可用，用户未录入
                        break;
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    } else {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"TouchID is not enrolled");
                break;
            case LAErrorPasscodeNotSet:
                NSLog(@"A passcode has not been set");
                break;
            default:
                NSLog(@"TouchID not available");
                break;
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}

- (void)masonryLayout {
    [self.touchIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.8f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.touchIDButton.mas_width).multipliedBy(0.4f);
    }];
    
    [self.passwordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.2f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4f);
        make.height.equalTo(self.passwordButton.mas_width).multipliedBy(0.4f);
    }];
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
