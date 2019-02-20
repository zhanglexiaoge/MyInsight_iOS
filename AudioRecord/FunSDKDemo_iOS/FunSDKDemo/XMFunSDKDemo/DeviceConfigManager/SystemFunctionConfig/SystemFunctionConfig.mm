//
//  SystemFunctionConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/8.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "SystemFunctionConfig.h"
#import "SystemFunction.h"
#import <FunSDK/FunSDK.h>
@interface SystemFunctionConfig ()
{
    SystemFunction functionCfg;
}
@end

@implementation SystemFunctionConfig

#pragma mark - 1、通过设备序列号获取设备各种能力级
- (void)getSystemFunction:(NSString *)deviceMac {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    CfgParam* paramfunctionCfg = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:functionCfg.Name()] andDevId:channel.deviceMac andChannel:-1 andConfig:&functionCfg andOnce:YES andSaveLocal:NO];//获取能力级
    [self AddConfig:paramfunctionCfg];
    [self GetConfig:[NSString stringWithUTF8String:functionCfg.Name()]];
}

#pragma mark - 获取AVEnc.SmartH264信息
- (void)getSmartH264Info{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevGetConfig_Json(SELF, SZSTR(channel.deviceMac), "AVEnc.SmartH264", 0);
}

#pragma mark - 设置AVEnc.SmartH264信息
- (void)setSmartH264Info:(int)smartH264{
    char param[1024];
    if (smartH264 == 1) {
        sprintf(param, "{ \"AVEnc.SmartH264\" : [ { \"SmartH264\" : true } ], \"Name\" : \"AVEnc.SmartH264\", \"SessionID\" : \"0x000006A9\" }");
    }else{
        sprintf(param, "{ \"AVEnc.SmartH264\" : [ { \"SmartH264\" : false } ], \"Name\" : \"AVEnc.SmartH264\", \"SessionID\" : \"0x000006A9\" }");
    }
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    FUN_DevSetConfig_Json(SELF, SZSTR(channel.deviceMac), "AVEnc.SmartH264",
                          (char *)param,(int)strlen(param) + 1,channel.channelNumber);
}

#pragma mark - 3、
- (void)OnGetConfig:(CfgParam *)param {
    [super OnGetConfig:param];
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *object  = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    if ([param.name isEqualToString:[NSString stringWithUTF8String:functionCfg.Name()]]) {
        //是否支持智能分析
        if (functionCfg.mAlarmFunction.VideoAnalyze.Value() == YES) {//老的智能分析
            object.sysFunction.NewVideoAnalyze = functionCfg.mAlarmFunction.VideoAnalyze.Value();
        }
        if (functionCfg.mAlarmFunction.NewVideoAnalyze.Value() == YES) {//新的智能分析
            object.sysFunction.NewVideoAnalyze = functionCfg.mAlarmFunction.NewVideoAnalyze.Value();
        }
        //是否支持智能快放
        if (functionCfg.mOtherFunction.SupportIntelligentPlayBack.Value() == YES) {
            object.sysFunction.SupportIntelligentPlayBack = functionCfg.mOtherFunction.SupportIntelligentPlayBack.Value();
        }
        //是否支持设置前端IP
        if (functionCfg.mOtherFunction.SupportSetDigIP.Value() == YES) {
            object.sysFunction.SupportSetDigIP = functionCfg.mOtherFunction.SupportSetDigIP.Value();
        }
        //是否支持433报警
        if (functionCfg.mAlarmFunction.Consumer433Alarm.Value() == YES) {
            object.sysFunction.IPConsumer433Alarm = functionCfg.mAlarmFunction.Consumer433Alarm.Value();
        }
        //是否支持h264+
        if(functionCfg.mEncodeFunction.SmartH264.Value() == YES){
            object.sysFunction.SupportSmartH264 = functionCfg.mEncodeFunction.SmartH264.Value();
        }
        //获取能力级之后的结果回调
        if ([self.delegate respondsToSelector:@selector(SystemFunctionConfigGetResult:)]) {
            [self.delegate SystemFunctionConfigGetResult:param.errorCode];
        }
    }
}

#pragma mark - 2、请求SystemFunction回调
- (void)OnFunSDKResult:(NSNumber *)pParam {
    [super OnFunSDKResult:pParam];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    if (msg->id == EMSG_DEV_GET_CONFIG_JSON){
        if (msg->param1 <= 0){
            [SVProgressHUD showErrorWithStatus:TS("EE_AS_SYS_GET_USER_INFO_CODE4")];
        }else{
            NSData *data = [[[NSString alloc]initWithUTF8String:msg->pObject] dataUsingEncoding:NSUTF8StringEncoding];
            if ( data == nil ){
                [SVProgressHUD showErrorWithStatus:TS("EE_AS_SYS_GET_USER_INFO_CODE4")];
                return;
            }
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ( appData == nil){
                [SVProgressHUD showErrorWithStatus:TS("EE_AS_SYS_GET_USER_INFO_CODE4")];
                return;
            }
            [SVProgressHUD dismiss];
            NSString* strConfigName = [appData valueForKey:@"Name"];
            if ([strConfigName isEqualToString:@"AVEnc.SmartH264"]){
                NSDictionary *infoDic = [[appData objectForKey:@"AVEnc.SmartH264"] objectAtIndex:0];
                //获取之后的结果回调
                if ([self.delegate respondsToSelector:@selector(SmartH264InfoConfigGetResult:smartH264:)]) {
                    [self.delegate SmartH264InfoConfigGetResult:msg->param1 smartH264:[[infoDic objectForKey:@"SmartH264"] boolValue]];
                }
            }
        }
    }
    else if (msg->id == EMSG_DEV_SET_CONFIG_JSON){
        if (msg->param1 <= 0){
            [SVProgressHUD showErrorWithStatus:TS("Error")];
        }else{
            [SVProgressHUD showSuccessWithStatus:TS("Success")];
        }
    }
}

@end
