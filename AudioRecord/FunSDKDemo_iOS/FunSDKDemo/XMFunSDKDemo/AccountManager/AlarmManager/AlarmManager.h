//
//  AlarmManager.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/5.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 设备报警，继承自 FunMsgListener，包括注册和注销设备报警，需要和设备报警开关同时使用
 如果需要设备报警推送到手机，则需要在这里注册报警推送，并且在设备报警配置中也要打开设备报警开关
 （这里是向报警服务器注册和注销设备信息，而报警配置中才是真正的打开设备报警配置）
 
 *****/
@protocol AlarmManagerDelegate <NSObject>
//注册设备报警结果
- (void)LinkAlarmDelegate:(NSString *)deviceMac Result:(NSInteger)result;
//注销设备报警结果
- (void)UnlinkAlarmAlarmDelegate:(NSString *)deviceMac Result:(NSInteger)result;
@end


typedef enum {
    DevelopmentType = 200,
    ProductionType = 3,
}PushType;

#import <Foundation/Foundation.h>
#import "FunMsgListener.h"

@interface AlarmManager : FunMsgListener

@property (nonatomic, assign) id <AlarmManagerDelegate> delegate;

+ (instancetype)getInstance;

#pragma mark 报警和注销报警
- (void)LinkAlarm:(NSString *)deviceMac DeviceName:(NSString *)devName;
- (void)UnlinkAlarm:(NSString *)deviceMac;
@end
