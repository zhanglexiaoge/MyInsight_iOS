//
//  PasswordConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/17.
//  Copyright © 2018年 XM. All rights reserved.
//
/******
 *
 * 修改设备密码功能
 *
 ******/
@protocol ChangePasswordConfigDelegate <NSObject>
//修改设备密码代理回调
- (void)changePasswordConfigResult:(NSInteger)result;

@end
#import "FunMsgListener.h"

@interface PasswordConfig : FunMsgListener

@property (nonatomic, assign) id <ChangePasswordConfigDelegate> delegate;

#pragma mark -  保存设备设备密码
- (void)changePassword:(NSString*)oldPsw newpassword:(NSString*)newPsw;
@end
