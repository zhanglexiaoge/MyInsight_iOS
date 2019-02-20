//
//  SystemInfoConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/7.
//  Copyright © 2018年 XM. All rights reserved.
//

/***
 
 获取设备基本信息 SystemInfo
 
*****/

@protocol SystemInfoConfigDelegate <NSObject>
//获取能力级回调信息
- (void)SystemInfoConfigGetResult:(NSInteger)result;
@end

#import "ConfigControllerBase.h"
@interface SystemInfoConfig : ConfigControllerBase

@property (nonatomic, assign) id <SystemInfoConfigDelegate> delegate;

#pragma mark - 通过设备序列号获取设备Systeminfo
- (void)getSystemInfo;
@end
