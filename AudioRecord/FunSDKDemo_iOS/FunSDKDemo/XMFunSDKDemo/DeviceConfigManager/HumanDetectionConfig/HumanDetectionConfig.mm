//
//  HumanDetectionConfig.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/27.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "HumanDetectionConfig.h"
#import "Detect_HumanDetectionDVR.h"

@implementation HumanDetectionConfig
{
    Detect_HumanDetectionDVR humanDetectionDVR;   //人形检测
}

#pragma mark - 获取人形检测配置
-(void)getHumanDetectConfig{
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&humanDetectionDVR andChannel:0 andCfgType:CFG_GET_SET]];
    
    [self GetConfig];
}

#pragma mark - 获取配置回调
-(void)OnGetConfig:(CfgParam *)param{
    [super OnGetConfig:param];
    if ([param.name isEqualToString:[NSString stringWithUTF8String:humanDetectionDVR.Name()]]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(HumanDetectionConfigGetResult:)]) {
            [self.delegate HumanDetectionConfigGetResult:param.errorCode];
        }
    }
}

#pragma mark 保存配置回调
- (void)OnSetConfig:(CfgParam *)param {
     if ([param.name isEqualToString:[NSString stringWithUTF8String:humanDetectionDVR.Name()]]){
         if (self.delegate && [self.delegate respondsToSelector:@selector(HumanDetectionConfigSetResult:)]) {
             [self.delegate HumanDetectionConfigSetResult:param.errorCode];
         }
     }
}

#pragma mark - 读取人形检测报警功能开关状态
-(int)getHumanDetectEnable{
    return humanDetectionDVR.Enable.Value();
}

#pragma mark - 读取人形检测报警录像开关状态
-(int)getHumanDetectRecordEnable{
    return humanDetectionDVR.mEventHandler.RecordEnable.Value();
}

#pragma mark - 读取人形检测报警抓图开关状态
-(int)getHumanDetectSnapEnable{
    return humanDetectionDVR.mEventHandler.SnapEnable.Value();
}

#pragma mark - 读取人形检测手机推送开关状态
-(int)getHumanDetectMessageEnable{
    return humanDetectionDVR.mEventHandler.MessageEnable.Value();
}

#pragma mark - 设置人形检测报警功能开关状态
-(void)setHumanDetectEnable:(int)enable{
    humanDetectionDVR.Enable = enable;
}

#pragma mark - 设置人形检测报警录像开关状态
-(void)setHumanDetectRecordEnable:(int)enable{
    humanDetectionDVR.mEventHandler.RecordEnable = enable;
}

#pragma mark - 设置人形检测报警抓图开关状态
-(void)setHumanDetectSnapEnable:(int)enable{
    humanDetectionDVR.mEventHandler.SnapEnable = enable;
}

#pragma mark - 设置人形检测手机推送开关状态
-(void)setHumanDetectMessageEnable:(int)enable{
    humanDetectionDVR.mEventHandler.MessageEnable = enable;
}

@end
