//
//  BuzzerConfig.h
//  FunSDKDemo
//
//  Created by Levi on 2019/1/4.
//  Copyright © 2019年 Levi. All rights reserved.
//

/***
 
 设备蜂鸣报警配置
 1.需要先获取设备能力级，判断是否支持蜂鸣报警配置
 2.正常操作报警配置开关
 
 *****/

#import "ConfigControllerBase.h"

@protocol BuzzerConfigDelegate <NSObject>

#pragma mark 获取设备报警配置结果回调
- (void)getDeviceBuzzerAlarmConfigResult:(BOOL)AlarmBellState;

#pragma mark 保存设备报警配置结果回调
- (void)setDeviceBuzzerAlarmConfigResult:(int)result;

@end

@interface BuzzerConfig : ConfigControllerBase

@property (nonatomic, weak) id <BuzzerConfigDelegate> delegate;

#pragma mark 获取设备报警配置
- (void)getDeviceBuzzerAlarmConfig;

#pragma mark 保存设备报警配置
- (void)setDeviceBuzzerAlarmConfig:(BOOL)AlarmBellState;

@end
