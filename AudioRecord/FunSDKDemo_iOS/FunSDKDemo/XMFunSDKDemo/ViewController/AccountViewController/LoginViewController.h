//
//  LoginViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/15.
//  Copyright © 2018年 XM. All rights reserved.
//

/**
 
 用户登录视图控制器
 当前两种登录方法:本地登录和云登录
 本地登录:不通过账号登录,只能搜索到局域网下的设备
 云登录:通过账号密码登录,可以对该账号下的所有设备进行操作
 */


#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextField *userNameTf;
@property (nonatomic, assign) IBOutlet UITextField *passwordTf;

- (IBAction)cloudLogin;
- (IBAction)localLogin;
- (IBAction)apLogin:(id)sender;

- (IBAction)registerUser;
@end
