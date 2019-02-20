//
//  SystemFunctionConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 获取设备各种通用能力级 SystemFunction
 
*****/

@protocol SystemFunctionConfigDelegate <NSObject>

@optional
//获取能力级回调信息
- (void)SystemFunctionConfigGetResult:(BOOL)result;
//获取h264+信息回调
- (void)SmartH264InfoConfigGetResult:(BOOL)result smartH264:(int)SmartH264;
@end

#import "ConfigControllerBase.h"

@interface SystemFunctionConfig : ConfigControllerBase

@property (nonatomic, assign) id <SystemFunctionConfigDelegate> delegate;

#pragma mark - 通过设备序列号获取设备各种能力级
- (void)getSystemFunction:(NSString *)deviceMac;
#pragma mark - 获取AVEnc.SmartH264信息
- (void)getSmartH264Info;
#pragma mark - 设置AVEnc.SmartH264信息
- (void)setSmartH264Info:(int)smartH264;
@end
