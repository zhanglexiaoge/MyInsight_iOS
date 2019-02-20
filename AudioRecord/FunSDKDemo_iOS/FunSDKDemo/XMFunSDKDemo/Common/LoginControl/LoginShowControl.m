//
//  LoginShowControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/7.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "LoginShowControl.h"

@implementation LoginShowControl

+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    static LoginShowControl *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LoginShowControl alloc] init];
    });
    return instance;
}
- (id)init {
    self = [super init];
    return self;
}

#pragma mark - 自动登陆开关
+ (void)setAutoLoginType:(BOOL)loginType {
    [NSUserDefaultData autoLoginSave:loginType];
}
+ (BOOL)getAutoLoginType {
    return [NSUserDefaultData ifAutoLogin];
}

#pragma mark - 登陆模式，包括账号登陆，本地登陆，ap登陆
LoginType appLoginType = loginTypeNone;
- (void)setLoginType:(int)loginType {
    appLoginType = loginType;
}
- (int)getLoginType {
    return appLoginType;
}

#pragma mark - 登陆账号和密码
NSString * userName = @""; NSString *password = @"";
- (void)setLoginUserName:(NSString*)user password:(NSString*)psw {
    userName = user; password = psw;
}
- (NSString *)getLoginUserName {
    return userName;
}
- (NSString *)getLoginPassword {
    return password;
}

#pragma mark - app推送功能是否打开
BOOL pushFunction = NO;
- (void)setPushFunction:(BOOL)open {
    pushFunction = open;
}
- (BOOL)getPushFunction {
    return pushFunction;
}

#pragma mark - 推送token
NSString *tokenStr = @"";
- (void)setPushToken:(NSString *)token {
    tokenStr = token;
}
- (NSString *)getPushToken {
    return tokenStr;
}
@end
