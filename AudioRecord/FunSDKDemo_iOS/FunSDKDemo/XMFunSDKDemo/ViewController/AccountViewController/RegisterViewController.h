//
//  RegisterViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/17.
//  Copyright © 2018年 XM. All rights reserved.
//

/**
 
账号注册功能
 *1、输入邮箱或者手机号（仅中国大陆支持手机号）获取验证码
 *2、按照格式要求输入用户名密码以及验证码
 *3、调用注册接口注册
 *4、如果验证码获取不到，可以跳过验证码，传空值直接注册
 *
 */

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@end
