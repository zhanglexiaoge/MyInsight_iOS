//
//  LoginShowControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/7.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
登录信息控制
 
 *****/
//登陆模式
typedef enum {
    loginTypeNone = 0,
    loginTypeCloud,//云登陆
    loginTypeLocal,//本地登陆
    loginTypeAP, //ap模式
    loginTypeWX,//微信
} LoginType;

#import <Foundation/Foundation.h>

@interface LoginShowControl : NSObject

+ (instancetype)getInstance;

#pragma mark - 自动登陆开关
+ (void)setAutoLoginType:(BOOL)loginType;
+ (BOOL)getAutoLoginType;

#pragma mark - 登陆模式
- (void)setLoginType:(int)loginType;
- (int)getLoginType;

#pragma mark - 登陆账号和密码
- (void)setLoginUserName:(NSString *)user password:(NSString *)psw;
- (NSString *)getLoginUserName;
- (NSString *)getLoginPassword;

#pragma mark - app推送功能是否打开
- (void)setPushFunction:(BOOL)open;
- (BOOL)getPushFunction;

#pragma mark - 推送token
- (void)setPushToken:(NSString *)token;
- (NSString *)getPushToken;
@end
