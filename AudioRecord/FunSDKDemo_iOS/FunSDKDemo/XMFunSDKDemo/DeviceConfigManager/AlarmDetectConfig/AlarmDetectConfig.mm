//
//  AlarmDetectConfig.m
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

#import "AlarmDetectConfig.h"
#import "Detect_MotionDetect.h"
#import "Detect_BlindDetect.h"
#import "Detect_LossDetect.h"

@interface AlarmDetectConfig () {
}
@property (nonatomic, assign) Detect_BlindDetect blindCfg; //视频遮挡数据对象
@property (nonatomic, assign) Detect_LossDetect lossCfg;//视频丢失数据对象
@property (nonatomic, assign) Detect_MotionDetect motionCfg;//移动侦测数据对象
@end

@implementation AlarmDetectConfig

#pragma mark 获取设备报警配置接口调用
- (void)getDeviceAlarmDetectConfig{
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //移动侦测
    CfgParam* paramMotionCfg = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:_motionCfg.Name()] andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&_motionCfg andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramMotionCfg];
    //视频遮挡
    CfgParam* paramBlindCfg = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:_blindCfg.Name()] andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&_blindCfg andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramBlindCfg];
    //视频丢失
    CfgParam* paramLossCfg = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:_lossCfg.Name()] andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&_lossCfg andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramLossCfg];
    //调用获取配置的命令
    [self GetConfig];
}
#pragma mark 获取配置回调信息
-(void)OnGetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_motionCfg.Name()]]) {
        //移动侦测回调
        if ([self.delegate respondsToSelector:@selector(getAlarmDetectConfigResult:)]) {
            [self.delegate getAlarmDetectConfigResult:param.errorCode ];
        }
    }
    if ( [param.name isEqualToString:[NSString stringWithUTF8String:_blindCfg.Name()]]) {
        //视频遮挡回调
        if ([self.delegate respondsToSelector:@selector(getAlarmDetectConfigResult:)]) {
            [self.delegate getAlarmDetectConfigResult:param.errorCode ];
        }
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_lossCfg.Name()]]) {
        //视频丢失回调
        if ([self.delegate respondsToSelector:@selector(getAlarmDetectConfigResult:)]) {
            [self.delegate getAlarmDetectConfigResult:param.errorCode ];
        }
    }
}
#pragma mark 保存设备报警配置接口调用
- (void)setDeviceAlarmDetectConfig {
    //发送保存配置的请求
    [self SetConfig];
}
#pragma mark 保存配置回调信息
- (void)OnSetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_motionCfg.Name()]]) {
    }
    if ( [param.name isEqualToString:[NSString stringWithUTF8String:_blindCfg.Name()]] ) {
    }
    if ([param.name isEqualToString:[NSString stringWithUTF8String:_lossCfg.Name()]]) {
        if ([self.delegate respondsToSelector:@selector(setAlarmDetectConfigResult:)]) {
            [self.delegate setAlarmDetectConfigResult:param.errorCode];
        }
    }
}


#pragma mark 读取各项配置的属性值
- (BOOL)getLossEnable { //视频都是开关
    return _lossCfg.Enable.Value();
}
- (BOOL)getMotionEnable { //移动侦测开关
    return _motionCfg.Enable.Value();
}
- (BOOL)getMotionRecordEnable { //移动侦测录像开关
    return _motionCfg.mEventHandler.RecordEnable.Value();
}
- (BOOL)getMotionSnapEnable { //移动侦测抓图开关
    return _motionCfg.mEventHandler.SnapEnable.Value();
}
- (BOOL)getMotionMessageEnable{ //移动侦测手机消息推送开关
    return _motionCfg.mEventHandler.MessageEnable.Value();
}
- (int)getMotionlevel{//获取移动侦测灵敏度
    return _motionCfg.Level.Value();
}
- (BOOL)getBlindEnable { //视频遮挡开关
    return _blindCfg.Enable.Value();
}
- (BOOL)getBlindRecordEnable { //视频遮挡录像开关
    return _blindCfg.mEventHandler.RecordEnable.Value();
}
- (BOOL)getBlindSnapEnable { //视频遮挡抓图开关
    return _blindCfg.mEventHandler.SnapEnable.Value();
}
- (BOOL)getBlindMessageEnable{ //视频遮挡手机消息推送开关
    return _blindCfg.mEventHandler.MessageEnable.Value();
}

#pragma - mark 设置各项配置具体的属性值
- (void)setLossEnable:(BOOL)Enable { //视频都是开关
     _lossCfg.Enable = Enable;
}
- (void)setMotionEnable:(BOOL)Enable { //移动侦测开关
    _motionCfg.Enable = Enable;
}
- (void)setMotionRecordEnable:(BOOL)Enable { //移动侦测录像开关
     _motionCfg.mEventHandler.RecordEnable = Enable;
}
- (void)setMotionSnapEnable:(BOOL)Enable { //移动侦测抓图开关
    _motionCfg.mEventHandler.SnapEnable = Enable;
}
- (void)setMotionMessageEnable:(BOOL)Enable{ //移动侦测手机消息推送开关
    _motionCfg.mEventHandler.MessageEnable =Enable;
}
- (void)setMotionlevel:(int)Level{//移动侦测灵敏度
    _motionCfg.Level = Level;
}
- (void)setBlindEnable:(BOOL)Enable { //视频遮挡开关
    _blindCfg.Enable =Enable;
}
- (void)setBlindRecordEnable:(BOOL)Enable { //视频遮挡录像开关
    _blindCfg.mEventHandler.RecordEnable =Enable;
}
- (void)setBlindSnapEnable:(BOOL)Enable { //视频遮挡抓图开关
    _blindCfg.mEventHandler.SnapEnable = Enable;
}
- (void)setBlindMessageEnable:(BOOL)Enable { //视频遮挡手机消息推送开关
    _blindCfg.mEventHandler.MessageEnable =Enable;
}

//这个回调方法是必须的，初步获取到的数据通过这个方法回调到底层进行解析
- (void)OnFunSDKResult:(NSNumber *) pParam {
    [super OnFunSDKResult:pParam];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
