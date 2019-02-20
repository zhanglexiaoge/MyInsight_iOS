//
//  AlarmDetectConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/18.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
 设备报警配置
 Detect_MotionDetect 移动侦测配置
 Detect_BlindDetect  视频遮挡配置
 Detect_LossDetect  视频丢失配置
 
 *****/

@protocol AlarmDetectConfigDelegate <NSObject>
//获取报警配置代理回调
- (void)getAlarmDetectConfigResult:(NSInteger)result;
//保存报警配置代理回调
- (void)setAlarmDetectConfigResult:(NSInteger)result;

@end

#import "ConfigControllerBase.h"


@interface AlarmDetectConfig : ConfigControllerBase

@property (nonatomic, assign) id <AlarmDetectConfigDelegate> delegate;

#pragma mark 获取设备报警配置
- (void)getDeviceAlarmDetectConfig;
#pragma mark 保存设备报警配置
- (void)setDeviceAlarmDetectConfig;


#pragma mark - - -下面是上层界面读取配置数据和修改配置数据的方法
#pragma mark 读取各项配置的属性值
- (BOOL)getLossEnable;//视频丢失开关

- (BOOL)getMotionEnable; //移动侦测开关

- (BOOL)getMotionRecordEnable; //移动侦测录像开关

- (BOOL)getMotionSnapEnable; //移动侦测抓图开关

- (BOOL)getMotionMessageEnable; //移动侦测手机消息推送开关

- (int)getMotionlevel;//获取移动侦测灵敏度

- (BOOL)getBlindEnable;//视频遮挡开关

- (BOOL)getBlindRecordEnable; //视频遮挡录像开关

- (BOOL)getBlindSnapEnable; //视频遮挡抓图开关

- (BOOL)getBlindMessageEnable; //视频遮挡手机消息推送开关

#pragma mark 设置各项配置具体的属性值
- (void)setLossEnable:(BOOL)Enable;//视频都是开关

- (void)setMotionEnable:(BOOL)Enable; //移动侦测开关

- (void)setMotionRecordEnable:(BOOL)Enable; //移动侦测录像开关

- (void)setMotionSnapEnable:(BOOL)Enable; //移动侦测抓图开关

- (void)setMotionMessageEnable:(BOOL)Enable; //移动侦测手机消息推送开关

- (void)setMotionlevel:(int)Level;//移动侦测灵敏度

- (void)setBlindEnable:(BOOL)Enable; //视频遮挡开关

- (void)setBlindRecordEnable:(BOOL)Enable; //视频遮挡录像开关

- (void)setBlindSnapEnable:(BOOL)Enable; //视频遮挡抓图开关

- (void)setBlindMessageEnable:(BOOL)Enable; //视频遮挡手机消息推送开关
@end
